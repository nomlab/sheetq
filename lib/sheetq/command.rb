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

    autoload :Base,        "#{dir}/base.rb"
    autoload :Init,        "#{dir}/init.rb"
    autoload :Nomnichi,    "#{dir}/nomnichi.rb"

  end # module Command
end # module Sheetq
