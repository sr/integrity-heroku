module Bob
  # A Builder will take care of building a buildable (wow, you didn't see
  # that coming, right?).
  class Builder
    attr_reader :buildable

    # Instantiate the Builder, passing an object that understands
    # the <tt>Buildable</tt> interface.
    def initialize(buildable)
      @buildable = buildable
    end

    # This is where the magic happens:
    #
    # 1. Notify the buildable that the build is starting.
    # 2. Check out the repo to the appropriate commit.
    # 3. Run the build script on it.
    # 4. Reports the build back to the buildable.
    def build
      Bob.logger.info "Building #{buildable.commit} of the #{buildable.scm} repo at #{buildable.uri}"

      in_background do
        buildable.start_building if buildable.respond_to?(:start_building)

        scm.with_commit(buildable.commit) { |commit_info|
          buildable.finish_building(commit_info, *run)
        }
      end
    end

    private

    def run
      output = nil
      status = false

      Bob.logger.debug("Running the build script for #{buildable.uri}")
      IO.popen(build_script, "r") { |io| output = io.read }
      status = $?.success?
      Bob.logger.debug("Ran build script `#{build_script}` and got:\n#{output}")

      [status, output]
    end

    def build_script
      "(cd #{scm.dir_for(buildable.commit)} && #{buildable.build_script} 2>&1)"
    end

    def scm
      @scm ||= SCM.new(buildable.scm, buildable.uri, buildable.branch)
    end

    def in_background(&block)
      Bob.engine.call(block)
    end
  end
end
