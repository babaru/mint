class Project < ActiveRecord::Base
  belongs_to :client
  belongs_to :parent, class_name: 'Project', foreign_key: 'parent_id'
  has_many :project_users
  has_many :users, through: :project_users
  attr_accessible :ended_at, :key, :level, :name, :started_at, :type, :client_id, :parent_id

  validates :name, presence: true
end
