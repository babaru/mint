module Mint
  module ExcelParsers
    class UserOvertimeRecordFileParser
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def parse
        workbook = RubyXL::Parser.parse(file_path)
        worksheet = workbook.worksheets[0]
        data = worksheet.extract_data
        title_row = data[0]
        user_names = []
        title_row.each_with_index do |cell, index|
          if index > 0
            user_names << cell
          end
        end

        result = []

        data.each_with_index do |row, rindex|
          if rindex > 0
            happened_at = row[0]
            row.each_with_index do |cell, cindex|
              if cindex > 0
                if is_cell_data_valid?(cell)
                  result << {happened_at: happened_at, user_name: user_names[cindex - 1], value: cell}
                end
              end
            end
          end
        end

        result
      end

      private

      def is_cell_data_valid?(cell)
        return false if cell.nil?
        return cell > 0 if cell.is_a?(Fixnum)
        false
      end
    end
  end
end