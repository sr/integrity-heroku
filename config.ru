require "init"

# Use a pool of 20 threads for parralel builds
Bob.engine = Bob::Engine::Threaded.new(2)

map "/github/SECRET_TOKEN" do
  use Bobette::GitHub
  run Bobette.new(Integrity::BuildableProject)
end

map "/" do
  run Integrity::App
end
