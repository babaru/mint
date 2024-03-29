class Project < ActiveRecord::Base

  belongs_to :client
  belongs_to :parent, class_name: 'Project', foreign_key: 'parent_id'
  has_many :children, class_name: 'Project', foreign_key: 'parent_id'
  has_many :project_users
  has_many :users, through: :project_users
  attr_accessible :ended_at, :key, :level, :name, :started_at, :type, :client_id, :parent_id, :user_ids

  validates :name, presence: true

  scope :top, where(parent_id: nil)
  scope :children, where('parent_id is NOT NULL')

  def total_recorded_hours
    TimeRecord.select(Arel::Nodes::NamedFunction.new('SUM', [TimeRecord.arel_table[:value]]).as('value')).where(project_id: self.id).first.value
  end

  class << self
    def migrate_children_time_records(user_id, started_at, ended_at)
        TimeRecord.transaction do
          Project.top.each do |project|
            project.children.each do |child|
              do_migrate_children_time_records(project, child, user_id, started_at, ended_at)
            end
          end
        end
      end

      private

      def do_migrate_children_time_records(top, current, user_id, started_at, ended_at)
        if current.id != top.id
          TimeRecord.where(project_id: current.id, user_id: user_id, recorded_on: (started_at.beginning_of_day..ended_at.end_of_day)).each do |tr|
            tr.update_attributes({project_id: top.id})
          end
        end
        current.children.each {|p| do_migrate_children_time_records(top, p, user_id, started_at, ended_at)} if current.children.length > 0
      end
  end
end
