class OvertimeRecord < ActiveRecord::Base
  belongs_to :user
  belongs_to :time_sheet
  attr_accessible :happened_at, :value, :time_sheet_id, :user_id
end
