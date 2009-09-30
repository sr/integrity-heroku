Gem::Specification.new do |s|
  s.name    = "bob"
  s.version = "0.3.0"
  s.date    = "2009-07-02"

  s.description = "Bob the Builder will build your code. Simple."
  s.summary     = "Bob builds!"
  s.homepage    = "http://integrityapp.com"

  s.authors = ["Nicolás Sanguinetti", "Simon Rozet"]
  s.email   = "info@integrityapp.com"

  s.require_paths     = ["lib"]
  s.rubyforge_project = "integrity"
  s.has_rdoc          = true
  s.rubygems_version  = "1.3.1"

  s.add_dependency "addressable"

  if s.respond_to?(:add_development_dependency)
    s.add_development_dependency "sr-mg"
    s.add_development_dependency "contest"
    s.add_development_dependency "redgreen"
    s.add_development_dependency "ruby-debug"
  end

  s.files = %w[
.gitignore
LICENSE
README.rdoc
Rakefile
bob.gemspec
lib/bob.rb
lib/bob/buildable.rb
lib/bob/builder.rb
lib/bob/engine.rb
lib/bob/engine/foreground.rb
lib/bob/engine/threaded.rb
lib/bob/scm.rb
lib/bob/scm/abstract.rb
lib/bob/scm/git.rb
lib/bob/scm/svn.rb
lib/bob/test.rb
lib/bob/test/buildable_stub.rb
lib/bob/test/scm/abstract.rb
lib/bob/test/scm/git.rb
lib/bob/test/scm/svn.rb
lib/core_ext/object.rb
test/bob_test.rb
test/engine/threaded_test.rb
test/helper.rb
test/scm/git_test.rb
test/scm/svn_test.rb
test/test_test.rb
]
end
