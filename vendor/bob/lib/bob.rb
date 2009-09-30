require "fileutils"
require "pathname"
require "yaml"
require "logger"
require "time"
require "addressable/uri"

require "bob/buildable"
require "bob/builder"
require "bob/scm"
require "bob/engine"

module Bob
  # Builds the specified <tt>buildable</tt>. This object must understand
  # the API described in the README.
  def self.build(buildable)
    Builder.new(buildable).build
  end

  # Directory where the code for the different buildables will be checked out.
  # Make sure the user running Bob is allowed to write to this directory.
  def self.directory
    Pathname(@directory || "/tmp")
  end

  # What will you use to build in background. Must respond to <tt>call</tt> and
  # take a block which will be run "in background". The default is to run in
  # foreground.
  def self.engine
    @engine || Engine::Foreground
  end

  # What to log with (must implement ruby's Logger interface). Logs to STDOUT
  # by default.
  def self.logger
    @logger || Logger.new(STDOUT)
  end

  class << self
    attr_writer :directory, :engine, :logger
  end
end
