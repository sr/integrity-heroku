require File.dirname(__FILE__) + "/helper"

require "bobette/github"

class BobetteGitHubTest < Bobette::TestCase
  def app
    Rack::Builder.new {
      use Bobette::GitHub do
        $head
      end
      use Rack::Lint
      run lambda { |env|
        Rack::Response.new(env["bobette.payload"].to_json, 200).finish
      }
    }
  end

  def setup
    super
    $head = false
  end

  def payload(repo, commits=[], is_private=false, branch="master")
    { "ref"        => "refs/heads/#{branch}",
      "after"      => commits.last["id"],
      "commits"    => commits,
      "repository" => {"url"     => "http://github.com/#{repo}",
                       "private" => is_private } }
  end

  def test_transform_payload
    commits = %w(b926de8 737bf26 8ba250e 78bb2de).map { |c| {"id" => c} }

    post("/", :payload =>
         payload("integrity/bob", commits).to_json) { |response|

      assert response.ok?
      assert_equal(
        { "uri"     => "git://github.com/integrity/bob",
          "scm"     => "git",
          "branch"  => "master",
          "commits" => commits }, JSON.parse(response.body))
    }

    post("/", :payload =>
         payload("integrity/bob", commits, true).to_json) { |response|

      assert response.ok?
      assert_equal "git@github.com:integrity/bob", JSON.parse(response.body)["uri"]
    }
  end

  def test_head_commit
    $head = true
    commits = %w(b926de8 737bf26 8ba250e 78bb2de).map { |c| {"id" => c} }

    post("/", :payload =>
         payload("integrity/bob", commits).to_json) { |response|

      assert response.ok?
      assert_equal [commits.last], JSON.parse(response.body)["commits"]
    }
  end

  def test_invalid_payload
    assert post("/").client_error?
    assert post("/", {}, "bobette.payload" => "</3").client_error?
  end
end
