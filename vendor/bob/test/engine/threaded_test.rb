require File.dirname(__FILE__) + "/../helper"

class ThreadedBobTest < Test::Unit::TestCase
  def setup
    super

    @repo = GitRepo.new(:test_repo)
    @repo.create
  end

  test "with a successful threaded build" do
    old_engine = Bob.engine

    repo.add_successful_commit
    commit_id = repo.commits.last["identifier"]
    buildable = BuildableStub.for(@repo, commit_id)

    begin
      Thread.abort_on_exception = true
      Bob.engine = Bob::Engine::Threaded.new(5)
      buildable.build
      Bob.engine.wait!

      assert_equal :successful,          buildable.status
      assert_equal "Running tests...\n", buildable.output

      commit = buildable.commit_info
      assert_equal "This commit will work", commit["message"]
      assert_equal Time.now.min,            commit["committed_at"].min
    ensure
      Bob.engine = old_engine
    end
  end

  class FakeLogger
    attr_reader :msg

    def error(msg)
      @msg = msg
    end
  end

  test "when something goes wrong" do
    logger = FakeLogger.new

    engine = Bob::Engine::Threaded.new(2, logger)
    engine.call(proc { fail "foo" })
    engine.wait!

    assert_equal "Exception occured during build: foo", logger.msg
  end
end
