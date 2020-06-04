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

      def append_row(sheet_name, resource)
        # https://developers.google.com/sheets/api/reference/rest/v4/spreadsheets.values/append
        # https://www.rubydoc.info/github/google/google-api-ruby-client/Google/Apis/SheetsV4/SheetsService#append_spreadsheet_value-instance_method
        # https://stackoverflow.com/questions/43207765/how-do-i-add-data-to-a-google-sheet-from-ruby
        value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [resource.to_a])
        response = client.append_spreadsheet_value(
          spreadsheet_id,
          "#{sheet_name}!A1",
          value_range_object,
          insert_data_option: "INSERT_ROWS",
          value_input_option: "RAW"
        )
      end

      def sheet(sheet_name, resource_class = nil)
        Sheet.new(self, sheet_name, resource_class)
      end

    end # class Spreadsheet
  end # module Service
end # module Sheetq
