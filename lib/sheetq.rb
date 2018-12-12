require "sheetq/version"

module Sheetq
  # Your code goes here...
  class ConfigurationError < StandardError ; end

  dir = File.dirname(__FILE__) + "/sheetq"

  autoload :Command,              "#{dir}/command.rb"
  autoload :Config,               "#{dir}/config.rb"
  autoload :GoogleClient,         "#{dir}/google_client.rb"
  autoload :Resource,             "#{dir}/resource.rb"
  autoload :VERSION,              "#{dir}/version.rb"
end
