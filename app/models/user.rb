class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_user_groups
  has_many :user_groups, through: :user_user_groups
  has_many :user_roles
  has_many :roles, through: :user_roles
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :role_ids

  before_save :set_default_role

  scope :normal_users, -> { joins(:roles).where("roles.name != 'system_admin' or roles.name is null")}

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  private

  def set_default_role
    if roles.blank?
      roles << Role.find_by_name('user')
    end
  end
end
