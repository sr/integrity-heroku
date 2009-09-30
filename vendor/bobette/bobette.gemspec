Gem::Specification.new do |s|
  s.name    = "bobette"
  s.version = "0.0.4"
  s.date    = "2009-07-17"

  s.summary     = "Bob's sister"
  s.description = "Bob's sister"

  s.homepage    = "http://integrityapp.com"

  s.authors = ["Nicolás Sanguinetti", "Simon Rozet"]
  s.email   = "info@integrityapp.com"

  s.require_paths     = ["lib"]
  s.rubyforge_project = "integrity"
  s.has_rdoc          = false
  s.rubygems_version  = "1.3.1"

  s.add_dependency "bob"
  s.add_dependency "rack"
  # TODO json too?

  if s.respond_to?(:add_development_dependency)
    s.add_development_dependency "rack-test"
    s.add_development_dependency "json"
    s.add_development_dependency "beacon"
  end

  s.files = %w[
LICENSE
README.md
Rakefile
examples/integrity.ru
lib/bobette.rb
lib/bobette/github.rb
test/bobette_github_test.rb
test/bobette_test.rb
test/helper.rb
test/helper/buildable_stub.rb
]
end
