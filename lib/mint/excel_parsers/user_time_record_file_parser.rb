module Mint
  module ExcelParsers
    class UserTimeRecordFileParser
      attr_reader :file_path

      def initialize(file_path)
        @file_path = file_path
      end

      def parse
        workbook = RubyXL::Parser.parse(file_path)
        worksheet = workbook.worksheets[0]
        data = worksheet.extract_data
        title_row = data[0]
        project_names = []
        title_row.each_with_index do |cell, index|
          if index > 0
            project_names << cell
          end
        end

        result = []

        data.each_with_index do |row, n|
          if n > 0
            recorded_on = row[0]
            project_names.each_with_index do |project_name, index|
              recorded_hours = row[index + 1]
              unless row.length <= index + 1 || recorded_hours.nil?
                result << {recorded_on: recorded_on, project_name: project_name, time_record: row[index + 1]}
              end
            end
          end
        end

        result
      end
    end
  end
end