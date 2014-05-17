class TimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task_type
  belongs_to :time_sheet
  attr_accessible :recorded_on, :value, :user_id, :project_id, :task_type_id, :time_sheet_id
end
