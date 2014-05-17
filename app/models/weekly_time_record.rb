class WeeklyTimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task_type
  attr_accessible :short_week_number, :value, :week_number
end
