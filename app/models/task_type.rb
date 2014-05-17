class TaskType < ActiveRecord::Base
  has_many :time_records
  attr_accessible :name
end
