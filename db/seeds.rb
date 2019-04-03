User.create!(name: 'admin',
             email: 'admin@auction.com',
             password: 'password',
             password_confirmation: 'password',
             role: 'admin',
             activated_at: Time.zone.now,
             address: '8 Ha Van Tinh',
             phone: '0972854570',
             birth_day: '1996-08-28',
             root: true)

10.times do |n|
  name  = Faker::Name.name
  email = Faker::Internet.email
  password = 'password'
  role = 'user'
  address = Faker::Address.street_address
  phone = Faker::Number.leading_zero_number(10)
  birth_day = Faker::Date.birthday(18, 65)
  User.create!(name: name,
               email: email,
               password: password,
               role: role,
               password_confirmation: password,
               activated_at: Time.zone.now,
               address: address,
               phone: phone,
               birth_day: birth_day)
end
