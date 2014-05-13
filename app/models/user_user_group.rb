class UserUserGroup < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_group
  attr_accessible :user_id, :user_group_id
end
