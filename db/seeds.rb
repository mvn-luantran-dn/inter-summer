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
