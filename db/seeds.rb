# frozen_string_literal: true

User.create!(name:  'admin',
             email: 'example@railstutorial.org',
             password: 'foobar',
             password_confirmation: 'foobar',
             role: 'admin',
             activated_at: Time.zone.now)

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n + 1}@railstutorial.org"
  password = 'password'
  role = 'user'
  User.create!(name:  name,
               email: email,
               password: password,
               role: role,
               password_confirmation: password,
               activated_at: Time.zone.now)
end
Category.create!(
  name: 'chuoi'
)
5.times do |n|
  name = Faker::Pokemon.name
  Category.create!(
    name: name,
    parent_id: 1
  )
end
Product.create!(
  name: 'hon',
  category_id: 1
)
10.times do |n|
  name = Faker::Music.name
  Product.create!(
    name: name,
    category_id: 2
  )
end
Auction.create!(
  product_id: '1',
  status: 'Bidding'
)
10.times do |n|
  status = Faker::Music.name
  Auction.create!(
    product_id: 1,
    status: status
  )
end  