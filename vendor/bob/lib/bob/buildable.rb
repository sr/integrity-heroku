module Bob
  # Mixin to add to your classes.
  module Buildable
    # Build itself.
    def build
      Bob.build(self)
    end

    # What kind of repository this buildable represents. Must
    # return a String ("git", "svn", etc.)
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def scm
      raise NotImplementedError
    end

    # Full URI to the repository to clone/checkout.
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def uri
      raise NotImplementedError
    end

    # Branch of the code you want to watch in order to build.
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def branch
      raise NotImplementedError
    end

    # Indentifier of the commit to build.
    #
    # The special identifier <tt>:head</tt> will be resolved to the head
    # commit of the current branch (for example, "HEAD" under git or the
    # latest revision under svn)
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def commit
      raise NotImplementedError
    end

    # Script that will be run in the buildable's checked out code,
    # if it returns a status code of 0 it will be considered a
    # successfull build. Else it will be considered a failed build.
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def build_script
      raise NotImplementedError
    end

    # Optional callback sent when the build starts. It can be used to calculate
    # the build duration for example.
    def start_building
    end

    # Callback sent after a build finishes. The first argument is a hash with
    # information about the commit.
    #
    # <tt>identifier</tt>:: A string with the commit identifier of the
    # commit that was built
    # <tt>author</tt>:: A string with the name/email of the committer
    # <tt>message</tt>:: The commit message
    # <tt>committed_at</tt>:: A Time object with the timestamp of the commit
    #
    # The second argument is a boolean indicating whether the build was
    # successful. Finally, the last one is a string with the full output
    # returned by the build process (STDOUT and STDERR interleaved)
    #
    # <b>You must implement this in the classes where you mixin this module</b>
    def finish_building(commit_info, build_status, build_output)
      raise NotImplementedError
    end
  end
end
