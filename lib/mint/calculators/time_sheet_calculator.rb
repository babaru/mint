module Mint
  module Calculators
    module TimeSheetCalculator
      def calculate_time_sheet(time_records, overtime_records)
        return [] if time_records.length == 0

        overtime_hours = 0
        if overtime_records
          overtime_records.each {|ot| overtime_hours += ot.value}
        end
        # overtime_hours = overtime_record.nil? ? 0 : overtime_record.value

        time_record_hours = time_records.inject(0) {|sum, item| sum += item.value}
        calculated_time_record_hours = time_record_hours - overtime_hours
        calculated_time_record_hours = 8 if calculated_time_record_hours < 8

        time_records_by_project = split_time_records_by_project(time_records)

        result = []

        time_records_by_project.each do |project_id, records|
          project_hours = records.inject(0) {|sum, i| sum += i.value}
          calculated_project_normal_hours = (project_hours / time_record_hours) * calculated_time_record_hours
          calculated_project_overtime_hours = (project_hours / time_record_hours) * overtime_hours

          result << {
            project_id: project_id,
            calculated_normal_hours: calculated_project_normal_hours,
            calculated_overtime_hours: calculated_project_overtime_hours,
            calculated_hours: calculated_project_normal_hours + calculated_project_overtime_hours,
            recorded_hours: project_hours,
            overtime_hours: overtime_hours,
            time_records: records
          }
        end
        result
      end

      private

      def split_time_records_by_project(time_records)
        result = {}
        time_records.each do |item|
          result[item.project_id] ||= []
          result[item.project_id] << item
        end
        result
      end
    end
  end
end