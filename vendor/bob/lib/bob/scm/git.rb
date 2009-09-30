module Bob
  module SCM
    class Git < Abstract
      protected

      def info(commit)
        format = "---%nidentifier: %H%nauthor: %an \
          <%ae>%nmessage: >-%n  %s%ncommitted_at: %ci%n"

        dump = YAML.load(`cd #{dir_for(commit)} && git show -s \
          --pretty=format:"#{format}" #{commit}`)

        dump.update("committed_at" => Time.parse(dump["committed_at"]))
      end

      def head
        `git ls-remote --heads #{uri} #{branch} | cut -f1`.chomp
      end

      private

      def checkout(commit)
        run "git clone #{uri} #{dir_for(commit)}" unless cloned?(commit)
        run "git fetch origin", dir_for(commit)
        run "git checkout origin/#{branch}", dir_for(commit)
        run "git reset --hard #{commit}", dir_for(commit)
      end

      def cloned?(commit)
        dir_for(commit).join(".git").directory?
      end
    end
  end
end
