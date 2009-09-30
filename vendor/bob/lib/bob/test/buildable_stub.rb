module Bob
  module Test
    class BuildableStub
      include Bob::Buildable

      def self.for(repo, commit)
        scm = (Bob::Test::GitRepo === repo) ? "git" : "svn"
        uri =
          if scm == "git"
            repo.path
          else
            "file://#{SvnRepo.server_root}/#{repo.name}"
          end
        # TODO: move onto repo object?
        branch = (scm == "git") ? "master" : ""
        build_script = "./test"

        new(scm, uri, branch, commit, build_script)
      end

      attr_reader :scm, :uri, :branch, :commit, :build_script,
        :repo, :status, :output, :commit_info

      def initialize(scm, uri, branch, commit, build_script)
        @scm = scm.to_s
        @uri = uri.to_s
        @branch = branch
        @commit = commit
        @build_script = build_script

        @status = nil
        @output = ""
        @commit_info = {}
      end

      def finish_building(commit_info, status, output)
        @commit_info = commit_info
        @status = status ? :successful : :failed
        @output = output
      end
    end
  end
end
