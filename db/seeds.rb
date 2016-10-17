# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = [
  {name: 'John', email: 'john@example.com'},
  {name: 'Greg', email: 'greg@example.com'},
  {name: 'Ken', email: 'ken@example.com'},
  {name: 'Tony', email: 'tony@example.com'},
  {name: 'Phani', email: 'phani@example.com'}
]

users.each do |user|
  user['password'] = 'test1234'
  user['password_confirmation'] = 'test1234'
  User.create(user)
  puts "create users with name: #{user[:name]}, password: #{user['password']}"
end

