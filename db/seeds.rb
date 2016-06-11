# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Begin loading seed data"

puts "Loading Roles:"
puts ActiveRecord::Base.connection.instance_variable_get(:@config)
roles = ["admin","digital_repository_admin","community_member"]

roles.each_with_index do | name, index |
  puts "  #{name}"
  Role.create!(name: name, id: index+1)
end

puts "Loading Users:"

users = ["aa729","cc414"]

users.each do | name |
  puts "  #{name}"
  User.create!(username: name)
end

Role.all.each do | role|
 puts "#{role.id} #{role.name}"
end

User.all.each do | user|
 puts "#{user.id} #{user.username}"
end

puts "Loading associations : "
ActiveRecord::Base.connection.execute "insert into roles_users values (2, 1)"
ActiveRecord::Base.connection.execute "insert into roles_users values (1, 1)"

puts "Data seeding finished"
