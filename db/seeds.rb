# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Begin loading seed data"

puts "Loading Roles:"
roles = ["admin","digital_repository_admin"]

roles.each do | name |
  puts "  #{name}"
  Role.first_or_create(name: name)
end

users = ["aa729"]

users.each do | name |
  puts "  #{name}"
  User.first_or_create(username: name)
end

ActiveRecord::Base.connection.execute "insert into roles_users values (2, 1)"

puts "Data seeding finished"
