module Bob
  module SCM
    class Svn < Abstract
      protected

      def info(revision)
        dump = `svn log --non-interactive --revision #{revision} #{uri}`.split("\n")
        meta = dump[1].split(" | ")

        { "identifier" => revision,
          "message" => dump[3],
          "author"  => meta[1],
          "committed_at" => Time.parse(meta[2]) }
      end


      def head
        `svn info #{uri}`.split("\n").detect { |l| l =~ /^Revision: (\d+)/ }
        $1.to_s
      end

      private

      def checkout(revision)
        unless checked_out?(revision)
          run "svn co -q #{uri} #{dir_for(revision)}"
        end

        run "svn up -q -r#{revision}", dir_for(revision)
      end

      def checked_out?(commit)
        dir_for(commit).join(".svn").directory?
      end
    end
  end
end
