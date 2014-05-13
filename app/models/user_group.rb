class UserGroup < ActiveRecord::Base
  has_many :user_user_groups
  has_many :users, through: :user_user_groups
  attr_accessible :name, :user_ids
end
