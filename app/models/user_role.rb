class UserRole < ActiveRecord::Base
  belongs_to :role
  belongs_to :user
  # attr_accessible :title, :body
end
