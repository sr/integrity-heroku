module Bob::Test
  class AbstractSCMRepo
    attr_reader :path, :name

    def initialize(name, base_dir=Bob.directory)
      @name   = name
      @path   = File.join(base_dir, @name.to_s)
    end

    def add_commit(message, &action)
      Dir.chdir(path) do
        yield action
        commit(message)
      end
    end

    def add_failing_commit
      add_commit "This commit will fail" do
        system "echo '#{build_script(false)}' > test"
        system "chmod +x test"
        add    "test"
      end
    end

    def add_successful_commit
      add_commit "This commit will work" do
        system "echo '#{build_script(true)}' > test"
        system "chmod +x test"
        add    "test"
      end
    end

    def commits
      raise NotImplementedError
    end

    def head
      commits.last["identifier"]
    end

    protected
      def add(file)
        raise NotImplementedError
      end

      def commit(message)
        raise NotImplementedError
      end

      def run(command)
        system "#{command} &>/dev/null"
      end

      def build_script(successful=true)
        <<-script
#!/bin/sh
echo "Running tests..."
exit #{successful ? 0 : 1}
script
      end
  end
end
