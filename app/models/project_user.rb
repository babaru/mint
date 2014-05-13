class ProjectUser < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  # attr_accessible :title, :body
end
