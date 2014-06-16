module Mint
  module ExcelParsers
    class UserLeaveRecordFileParser
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

        result = {}

        data.each_with_index do |row, rindex|
          if rindex > 0
            happened_at = row[0]
            row.each_with_index do |cell, cindex|
              if cindex > 0
                if is_cell_data_valid?(cell)
                  user_name = user_names[cindex - 1].strip.downcase
                  result[user_name] ||= {}
                  result[user_name][happened_at] ||= 0
                  result[user_name][happened_at] += cell
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
        return cell > 0 if cell.is_a?(Fixnum) || cell.is_a?(Float)
        false
      end
    end
  end
end