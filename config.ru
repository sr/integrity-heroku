require "init"

Bob.engine = Bob::Engine::Threaded.new(2)

map "/github/SECRET_TOKEN" do
  use Bobette::GitHub
  run Bobette.new(Integrity::BuildableProject)
end

map "/" do
  run Integrity::App
end
