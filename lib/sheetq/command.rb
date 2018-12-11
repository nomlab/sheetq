module Sheetq
  module Command

    def self.logger
      @logger
    end

    def self.client
      @client
    end

    class << self
      attr_writer :logger, :client
    end

    dir = File.dirname(__FILE__) + "/command"

    autoload :Init,        "#{dir}/init.rb"

  end # module Command
end # module Sheetq
