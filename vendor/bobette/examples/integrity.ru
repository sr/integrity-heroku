require "integrity"
require "bobette"
require "bobette/github"

class Integrity::Project
  def self.new(payload)
    # Auto-create!
    first_or_create(:kind => payload["kind"],
      :uri => payload["uri"],
      :branch => payload["master"]
    )
  end
end

map "/github" do
  use Bobette::GitHub
  run Bobette.new(Integrity::Project)
end

Integrity.new(:database_uri => "sqlite3:integrity.db")
DataMapper.auto_migrate!

map "/" do
  run Integrity::App
end
