class LeaveRecord < TimeRecord
  # validates :project_id, presencex: false

  def to_user_feed
    item = super
    item[:title] = "#{self.user.name}: ?"
    item
  end

  def as_json(options={})
    item = super(options)
    item[:user_name] = self.user.name
    item[:title] = "#{self.user.name}: ?"
    item
  end
end