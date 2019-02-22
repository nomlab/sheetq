module Sheetq
  module Service
    class Spreadsheet < Base
      attr_reader :client, :spreadsheet_id

      def initialize(client, spreadsheet_id)
        @client, @spreadsheet_id = client, spreadsheet_id
      end

      def get_spreadsheet_values(range)
        client.get_spreadsheet_values(spreadsheet_id, range)
      end

      def sheet(sheet_name, resource_class = nil)
        Sheet.new(self, sheet_name, resource_class)
      end

    end # class Spreadsheet
  end # module Service
end # module Sheetq
