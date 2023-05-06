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

30.times do |n|
  User.create!(name: Faker::Name.name,
               email: Faker::Internet.unique.email,
               password: '111111',
               password_confirmation: '111111'
  )
end
20.times do |n|
  user = User.first
  user.tasks.create!(title: Faker::Lorem.word, created_at: n.days.ago)
end
users = User.where(id: 1..3)
1.upto(3) do |n| 
  users.each { |user| user.tasks.create!(title: Faker::Lorem.word, completed: true, created_at: n.days.ago) }
end

users = User.all
user = User.first
following = users[2..20]
followed = users[3..25]
following.each { |followed_user| user.follow(followed_user) }
followed.each { |follower_user| follower_user.follow(user) }
