class MonthlyTimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task_type
  attr_accessible :month_number, :value
end
