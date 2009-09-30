require "test/unit"
require "contest"
require "hpricot"

begin
  require "redgreen"
  require "ruby-debug"
rescue LoadError
end

$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__) + "/../lib"),
  File.expand_path(File.dirname(__FILE__) + "/../test/helper"))

require "bob"
require "bob/test"

class Test::Unit::TestCase
  include Bob
  include Bob::Test

  attr_reader :repo

  def setup
    Bob.logger = Logger.new("/dev/null")
    Bob.engine = Bob::Engine::Foreground
    Bob.directory = Pathname(__FILE__).dirname.join("..", "tmp").expand_path

    Bob.directory.rmtree if Bob.directory.directory?
    Bob.directory.mkdir
  end
end
