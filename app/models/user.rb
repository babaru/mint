class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessor :login

  has_many :user_user_groups
  has_many :user_groups, through: :user_user_groups
  has_many :user_roles
  has_many :roles, through: :user_roles, class_name: 'Role'
  has_many :project_users
  has_many :projects, through: :project_users
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name,
    :role_ids, :user_group_ids, :first_name, :last_name

  attr_accessible :login

  scope :tracked, -> { joins(:roles).where("roles.name = 'tracked_user'")}
  scope :system_admin, -> { joins(:roles).where("roles.name = 'system_admin'")}
  scope :ordered, order('first_name asc')

  validates :email,
    :uniqueness => {
      :case_sensitive => false
    }

  validates :name,
    :uniqueness => {
      :case_sensitive => false
    }

  def full_name
    "#{first_name} #{last_name}"
  end

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

  def is_sys_admin?
    has_role?(:system_admin)
  end

  def is_normal_user?
    has_role?(:tracked_user) && !has_role?(:time_admin)
  end

  def is_time_admin?
    has_role?(:time_admin)
  end

  def self.temp_create!(name)
    new_uuid = UUID.new.generate
    User.create!({name: name, email: "#{new_uuid}@email.com", password: '12345678', password_confirmation: '12345678'})
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
