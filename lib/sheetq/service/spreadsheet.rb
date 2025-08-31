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

      def get_row_num(sheet_name, word)
        row_num = nil
        values = client.get_spreadsheet_values(spreadsheet_id, sheet_name).values
        values.each_with_index do |row, index|
          if row.any? { |cell| cell == word}
            row_num = index + 1
            return row_num
            break
          end
        end
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

      def update_row(sheet_name, resource, row_num)
        value_range_object = Google::Apis::SheetsV4::ValueRange.new(values: [resource.to_a])
        target = 'A' + row_num.to_s
        response = client.update_spreadsheet_value(
          spreadsheet_id,
          "#{sheet_name}!#{target}",
          value_range_object,
          value_input_option: "RAW"
        )
      end

      def delete_row(sheet_name, row_num)
        sheet_meta = client.get_spreadsheet(spreadsheet_id)
        sheet = sheet_meta.sheets.find { |s| s.properties.title == sheet_name }
        sheet_id = sheet.properties.sheet_id

        delete_request = Google::Apis::SheetsV4::Request.new(
          delete_dimension: Google::Apis::SheetsV4::DeleteDimensionRequest.new(
            range: Google::Apis::SheetsV4::DimensionRange.new(
              sheet_id: sheet_id,
              dimension: "ROWS",
              start_index: row_num - 1, # 0ベースに変換
              end_index: row_num # 削除する行の次の行
            )
          )
        )
      
        batch_update_request = Google::Apis::SheetsV4::BatchUpdateSpreadsheetRequest.new(
          requests: [delete_request]
        )
        client.batch_update_spreadsheet(spreadsheet_id, batch_update_request)
      end

      def sheet(sheet_name, resource_class = nil)
        Sheet.new(self, sheet_name, resource_class)
      end

    end # class Spreadsheet
  end # module Service
end # module Sheetq
