class TimeSheet < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  has_many :time_records
  has_one :overtime_record
  attr_accessible :calculated_hours, :overtime_hours, :recorded_on, :recorded_hours, :user_id, :project_id, :calculated_normal_hours, :calculated_overtime_hours
end
