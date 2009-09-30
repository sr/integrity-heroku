require File.dirname(__FILE__) + "/helper"

class BobetteTest < Bobette::TestCase
  def app
    @app ||= Rack::Builder.new {
      use Rack::Lint
      run Bobette.new(BuildableStub)
    }
  end

  def payload(repo, branch="master")
    { "branch"  => branch,
      "commits" => repo.commits.map { |c| {"id" => c[:identifier]} },
      "uri"     => repo.path,
      "scm"     => "git" }
  end

  def setup
    super

    @repo = GitRepo.new(:my_test_project)
    @repo.create
    3.times { |i|
      i.odd? ? @repo.add_successful_commit : @repo.add_failing_commit
    }

    @metadata = {}
    @builds   = {}

    Beacon.watch(:start) { |commit_id, commit_info|
      @metadata[commit_id] = commit_info
    }

    Beacon.watch(:finish) { |commit_id, status, output|
      @builds[commit_id] = [status ? :successful : :failed, output]
    }
  end

  def test_valid_payload
    assert post("/", {}, "bobette.payload" => payload(@repo)).ok?

    assert_equal 4, @metadata.count
    assert_equal 4, @builds.count

    commit = @repo.head

    assert_equal :failed, @builds[commit].first
    assert_equal "Running tests...\n", @builds[commit].last
    assert_equal "This commit will fail", @metadata[commit][:message]
  end

  def test_invalid_payload
    # TODO
    assert_raise(NoMethodError) { assert post("/") }
    assert_raise(NoMethodError) { post("/", {}, "bobette.payload" => "</3") }
  end

  def test_no_buildable
    BuildableStub.no_buildable = true

    payload = payload(@repo).update("branch" => "unknown")

    post("/", {}, "bobette.payload" => payload) { |response|
      assert_equal 200, response.status
    }
  end
end
