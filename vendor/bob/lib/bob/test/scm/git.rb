require File.dirname(__FILE__) + "/abstract"

module Bob::Test
  class GitRepo < AbstractSCMRepo
    def create
      FileUtils.mkdir(path)

      Dir.chdir(path) do
        run "git init"
        run "git config user.name 'John Doe'"
        run "git config user.email 'johndoe@example.org'"
        run "echo 'just a test repo' >> README"
        add "README"
        commit "First commit"
      end
    end

    def commits
      Dir.chdir(path) do
        commits = `git log --pretty=oneline`.collect { |l| l.split(" ").first }
        commits.inject([]) do |commits, sha1|
          format  = "---%nmessage: >-%n  %s%ntimestamp: %ci%n" +
            "identifier: %H%nauthor: %n name: %an%n email: %ae%n"
          commits << YAML.load(`git show -s --pretty=format:"#{format}" #{sha1}`)
        end.reverse
      end
    end

    def head
      Dir.chdir(path) do
        `git log --pretty=format:%H | head -1`.chomp
      end
    end

    def short_head
      head[0..6]
    end

    protected
      def add(file)
        run "git add #{file}"
      end

      def commit(message)
        run %Q{git commit -m "#{message}"}
      end
  end
end
