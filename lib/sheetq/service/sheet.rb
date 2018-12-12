module Sheetq
  module Service
    class Sheet < Base
      attr_reader :client, :spreadsheet_id, :sheet_name

      def initialize(client, spreadsheet_id, sheet_name, resource_class)
        @client, @spreadsheet_id, @sheet_name, @resource_class = client, spreadsheet_id, sheet_name, resource_class
        @column_names = []
      end

      def fetch(range = nil)
        range = if range
                  sheet_name + "!" + range
                else
                  sheet_name
                end

        max_cols = 0

        resources = []

        response = client.get_spreadsheet_values(spreadsheet_id, range)

        response.values.each_with_index do |row, index|
          if index == 0
            @column_names = row
            max_cols = row.length
            next
          end
          row[max_cols - 1] = nil if row.length < max_cols
          resources << @resource_class.new(*row)
        end
        return resources
      end

    end # class Sheet
  end # module Service
end # module Sheetq
