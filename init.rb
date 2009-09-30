$LOAD_PATH.unshift(*Dir["#{File.dirname(__FILE__)}/vendor/**/lib"])
gem "data_objects", "= 0.10.0"
require "integrity"

Integrity.new(
  # Edit this! ex: http://falling-flower-54.heroku.com
  #:base_uri => nil,

  # Uncomment to setup a password
  # :use_basic_auth => true,
  # :admin_username => "admin",
  # :admin_password => "passwd",

  :database_uri     => ENV["DATABASE_URL"],
  :export_directory => File.dirname(__FILE__) + "/tmp",
  :log => File.dirname(__FILE__) + "/tmp/integrity.log"
)


