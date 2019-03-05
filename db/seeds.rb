User.create!(name: 'admin',
             email: 'admin@auction.com',
             password: 'password',
             password_confirmation: 'password',
             role: 'admin',
             activated_at: Time.zone.now)

10.times do |n|
  name  = Faker::Name.name
  email = "user-#{n + 1}@auction.com"
  password = 'password'
  role = 'user'
  User.create!(name: name,
               email: email,
               password: password,
               role: role,
               password_confirmation: password,
               activated_at: Time.zone.now)
end
