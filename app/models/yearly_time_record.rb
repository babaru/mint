class YearlyTimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task_type
  attr_accessible :value, :year_number
end
