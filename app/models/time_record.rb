class TimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  attr_accessible :recorded_at, :recorded_on, :value, :user_id, :project_id
end
