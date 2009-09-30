module Bobette::TestHelper
  class BuildableStub < Bob::Test::BuildableStub
    class << self
      attr_accessor :no_buildable
    end

    def self.call(payload)
      return [] if no_buildable

      scm          = payload["scm"]
      uri          = payload["uri"]
      branch       = payload["branch"]
      build_script = "./test"

      payload["commits"].map { |commit|
        new(scm, uri, branch, commit["id"], build_script)
      }
    end

    def start_building(commit_id, commit_info)
      Beacon.fire(:start, commit_id, commit_info)
    end

    def finish_building(commit_id, status, output)
      Beacon.fire(:finish, commit_id, status, output)
    end
  end
end
