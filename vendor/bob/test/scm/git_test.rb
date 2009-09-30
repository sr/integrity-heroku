require File.dirname(__FILE__) + "/../helper"

class BobGitTest < Test::Unit::TestCase
  def setup
    super

    @repo = GitRepo.new(:test_repo)
    @repo.create
  end

  def path(uri, branch="master")
    SCM::Git.new(uri, branch).__send__(:path)
  end

  test "converts repo uri into a path" do
    assert_equal "git-github-com-integrity-bob-master",
      path("git://github.com/integrity/bob")
    assert_equal "git-example-org-foo-repo-master",
      path("git@example.org:~foo/repo")
    assert_equal "tmp-repo-git-master", path("/tmp/repo.git")
    assert_equal "tmp-repo-git-foo",    path("/tmp/repo.git", "foo")
  end

  test "with a successful build" do
    repo.add_successful_commit

    commit_id = repo.commits.last["identifier"]

    buildable = BuildableStub.for(@repo, commit_id)
    buildable.build

    assert_equal :successful,          buildable.status
    assert_equal "Running tests...\n", buildable.output
    assert_equal "This commit will work", buildable.commit_info["message"]
    assert_equal commit_id,               buildable.commit_info["identifier"]
    assert buildable.commit_info["committed_at"].is_a?(Time)
  end

  test "with a failed build" do
    repo.add_failing_commit

    commit_id = repo.commits.last["identifier"]
    buildable = BuildableStub.for(@repo, commit_id)

    buildable.build

    assert_equal :failed,              buildable.status
    assert_equal "Running tests...\n", buildable.output
    assert_equal "This commit will fail", buildable.commit_info["message"]
    assert_equal commit_id,               buildable.commit_info["identifier"]
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
