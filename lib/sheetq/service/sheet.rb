module Sheetq
  module Service
    class Sheet < Base
      attr_reader :spreadsheet, :sheet_name

      def initialize(spreadsheet, sheet_name, resource_class = nil)
        @spreadsheet, @sheet_name, @resource_class = spreadsheet, sheet_name, resource_class
        @column_names = []
      end

      def append_row(resource)
        unless resource.is_a?(@resource_class)
          fail "Invalid resource #{resource.class} to append sheet #{sheet_name}"
        end
        spreadsheet.append_row(sheet_name, resource)
      end

      def fetch(range = nil)
        range = if range
                  sheet_name + "!" + range
                else
                  sheet_name
                end

        max_cols = 0

        resources = []

        response = spreadsheet.get_spreadsheet_values(range)

        response.values.each_with_index do |row, index|
          if index == 0
            @column_names = row
            max_cols = row.length
            next
          end
          row[max_cols - 1] = nil if row.length < max_cols
          if @resource_class
            resources << @resource_class.new(*row)
          else
            resources << row
          end
        end
        return resources
      end

    end # class Sheet
  end # module Service
end # module Sheetq
