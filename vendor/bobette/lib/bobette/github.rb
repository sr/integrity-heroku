require "json"

module Bobette
  class GitHub
    def initialize(app, &block)
      @app  = app
      @head = block || Proc.new { false }
    end

    def call(env)
      payload = Rack::Request.new(env).POST["payload"] || ""
      payload = JSON.parse(payload)
      payload["scm"]    = "git"
      payload["uri"]    = uri(payload.delete("repository"))
      payload["branch"] = payload.delete("ref").split("/").last
      if (head = payload.delete("after")) && @head.call
        payload["commits"] = [{"id" => head}]
      end

      @app.call(env.update("bobette.payload" => payload))
    rescue JSON::JSONError
      Rack::Response.new("Unparsable payload", 400).finish
    end

    def uri(repository)
      if repository["private"]
        "git@github.com:#{URI(repository["url"]).path[1..-1]}"
      else
        URI(repository["url"]).tap { |u| u.scheme = "git" }.to_s
      end
    end
  end
end
