
system_admin_role = Role.create(name: 'system_admin')
puts "Created role: #{system_admin_role.name}"

tracked_user_role = Role.create(name: 'tracked_user')
puts "Created role: #{tracked_user_role.name}"

time_admin_role = Role.create(name: 'time_admin')
puts "Created role: #{time_admin_role.name}"

admin = User.create(email: 'admin@mint.io', password: '12345678', password_confirmation: '12345678')
admin.roles << system_admin_role
puts "Created admin: #{admin.email}"

user_group = UserGroup.create(name: 'manager')
puts "Created user group: #{user_group.name}"

user_group = UserGroup.create(name: 'developer')
puts "Created user group: #{user_group.name}"

user_group = UserGroup.create(name: 'tester')
puts "Created user group: #{user_group.name}"