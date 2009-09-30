require File.dirname(__FILE__) + "/../helper"

class BobSvnTest < Test::Unit::TestCase
  def setup
    super

    @repo = SvnRepo.new(:test_repo)
    @repo.create
  end

  def path(uri)
    SCM::Svn.new(uri, "").__send__(:path)
  end

  test "converts svn repo uri into a path" do
    assert_equal "http-rubygems-rubyforge-org-svn",
      path("http://rubygems.rubyforge.org/svn/")

    assert_equal "svn-rubyforge-org-var-svn-rubygems",
      path("svn://rubyforge.org/var/svn/rubygems")

    assert_equal "svn-ssh-developername-rubyforge-org-var-svn-rubygems",
      path("svn+ssh://developername@rubyforge.org/var/svn/rubygems")

    assert_equal "home-user-code-repo",
      path("/home/user/code/repo")
  end

  test "with a successful build" do
    repo.add_successful_commit

    buildable = BuildableStub.for(@repo, "2")
    buildable.build

    assert_equal :successful,          buildable.status
    assert_equal "Running tests...\n", buildable.output
    assert_equal "This commit will work", buildable.commit_info["message"]
    assert_equal "2",                     buildable.commit_info["identifier"]
    assert buildable.commit_info["committed_at"].is_a?(Time)
  end

  test "with a failed build" do
    repo.add_failing_commit

    buildable = BuildableStub.for(@repo, "2")
    buildable.build

    assert_equal :failed,              buildable.status
    assert_equal "Running tests...\n", buildable.output
    assert_equal "This commit will fail", buildable.commit_info["message"]
    assert_equal "2",                     buildable.commit_info["identifier"]
    assert buildable.commit_info["committed_at"].is_a?(Time)
  end

  test "can build the head of a repository" do
    repo.add_failing_commit
    repo.add_successful_commit

    buildable = BuildableStub.for(@repo, :head)
    buildable.build

    assert_equal :successful,          buildable.status
    assert_equal "Running tests...\n", buildable.output
    assert_equal repo.head,            buildable.commit_info["identifier"]
  end
end
