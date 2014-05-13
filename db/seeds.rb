# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
user = User.create(email: 'admin@mint.io', password: '12345678', password_confirmation: '12345678')
puts "Created user: #{user.email}"

role = Role.create(name: 'system_admin')
puts "Created role: #{role.name}"

role = Role.create(name: 'user')
puts "Created role: #{role.name}"

user_group = UserGroup.create(name: 'manager')
puts "Created user group: #{user_group.name}"

user_group = UserGroup.create(name: 'developer')
puts "Created user group: #{user_group.name}"

user_group = UserGroup.create(name: 'tester')
puts "Created user group: #{user_group.name}"