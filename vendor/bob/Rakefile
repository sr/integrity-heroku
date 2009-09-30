require "rake/testtask"

rdoc_sources = %w(hanna/rdoctask rdoc/task rake/rdoctask)
begin
  require rdoc_sources.shift
rescue LoadError
  retry
end

begin
  require "metric_fu" if RUBY_VERSION < "1.9"
rescue LoadError
end

begin
  require "mg"
  MG.new("bob.gemspec")
rescue LoadError
end

desc "Default: run all tests"
task :default => :test

SCMs = %w[git svn]

desc "Run unit tests"
task :test => SCMs.map { |scm| "test:#{scm}" } do
  ruby "test/bob_test.rb"
  ruby "test/test_test.rb"
  ruby "test/engine/threaded_test.rb"
end

SCMs.each { |scm|
  desc "Run unit tests with #{scm}"
  task "test:#{scm}" do
    ruby "test/scm/#{scm}_test.rb"
  end
}

(defined?(RDoc::Task) ? RDoc::Task : Rake::RDocTask).new do |rd|
  rd.main = "README.rdoc"
  rd.title = "Documentation for Bob the Builder"
  rd.rdoc_files.include("README.rdoc", "LICENSE", "lib/**/*.rb")
  rd.rdoc_dir = "doc"
end
