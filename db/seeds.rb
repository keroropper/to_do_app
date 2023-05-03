# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name: 'ryoya',
             email: 'test@example.com', 
             password: '111111',
             password_confirmation: '111111')

10.times do |n|
  User.create!(name: Faker::Name.name,
               email: "test#{n}@example.com",
               password: '111111',
               password_confirmation: '111111'
  )
end

users = User.where(id: 1..5)
1.upto(3) do |n| 
  title = Faker::Lorem.word
  users.each { |user| user.tasks.create!(title: title, created_at: n.days.ago) }
end

users = User.all
user = User.first
following = users[2..8]
followed = users[3..10]
following.each { |followed_user| user.follow(followed_user) }
followed.each { |follower_user| follower_user.follow(user) }
