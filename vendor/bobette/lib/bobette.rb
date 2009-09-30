require "bob"

module Bobette
  def self.new(buildable)
    App.new(buildable)
  end

  class App
    attr_reader :buildable

    def initialize(buildable)
      @buildable = buildable
    end

    def call(env)
      payload   = env["bobette.payload"]

      @buildable.call(payload).each { |buildable|
        buildable.build if buildable.respond_to?(:build)
      }

      [200, {"Content-Type" => "text/plain"}, ["OK"]]
    end
  end
end
