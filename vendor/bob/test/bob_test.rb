require File.dirname(__FILE__) + "/helper"

class BobTest < Test::Unit::TestCase
  test "directory" do
    Bob.directory = "/foo/bar"
    assert_equal "/foo/bar", Bob.directory.to_s
    assert_instance_of Pathname, Bob.directory
  end

  test "logger" do
    logger = Logger.new("/tmp/bob.log")
    Bob.logger = logger

    assert_same logger, Bob.logger
  end

  test "engine" do
    engine = Object.new
    Bob.engine = engine

    assert_same engine, Bob.engine
  end
end
