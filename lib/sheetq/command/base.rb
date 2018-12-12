module Sheetq
  module Command
    class Base

      private

      def logger
        Sheetq::Command.logger
      end

      def client
        Sheetq::Command.client
      end

      def exit_if_error(message, error, logger)
        return true unless error
        logger.error "#{error.message.split(':').last.strip} #{message}."
        exit 1
      end

    end # class Base
  end # module Command
end # module Sheetq
