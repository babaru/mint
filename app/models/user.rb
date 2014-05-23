class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_user_groups
  has_many :user_groups, through: :user_user_groups
  has_many :user_roles
  has_many :roles, through: :user_roles, class_name: 'Role'
  has_many :project_users
  has_many :projects, through: :project_users
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :role_ids, :user_group_ids

  scope :tracking, -> { joins(:roles).where("roles.name = 'tracking_user'")}
  scope :system_admin, -> { joins(:roles).where("roles.name = 'system_admin'")}

  validates :name, uniqueness: true
  validates :email, uniqueness: true

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def self.temp_create!(name)
    new_uuid = UUID.new.generate
    User.create!({name: name, email: "#{new_uuid}@email.com", password: '12345678', password_confirmation: '12345678'})
  end
end
