class TimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :project
  belongs_to :task_type
  belongs_to :time_sheet
  attr_accessible :recorded_on, :value, :user_id, :project_id, :task_type_id, :time_sheet_id, :remark, :started_at, :ended_at

  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :recorded_on, presence: true
  validates :started_at, presence: true
  validates :ended_at, presence: true
  validates :value, presence: true

  def as_json(options={})
    item = super(options)
    item['project_name'] = self.project.name
    item
  end
end
