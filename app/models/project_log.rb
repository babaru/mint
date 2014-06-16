class ProjectLog < ActiveRecord::Base
  belongs_to :project
  attr_accessible :recorded_on, :remark, :type, :project_id
end
