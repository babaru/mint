module Mint
  module Calculators
    module ProjectTimeRecordCalculator
      def self.migrate_children_time_records
        TimeRecord.transaction do
          Project.top.each do |project|
            Mint::Calculators::ProjectTimeRecordCalculator.migrate_children_project(project, project)
          end
        end
      end

      private

      def self.migrate_children_project(top, current)
        TimeRecord.where(project_id: current.id).each {|tr| tr.project = top; tr.save! } if current.id != top.id
        current.projects.each {|p| Mint::Calculators::ProjectTimeRecordCalculator.migrate_children_project(top, p)} if current.project.length > 0
      end
    end
  end
end