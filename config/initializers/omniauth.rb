Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '816738921165-j7ulsn4m2tpv148jvcu3hf9qbuq0egmo.apps.googleusercontent.com', 'paJ9gyBq9Kgw2Dh0spWAPc_Q'
  provider :facebook, '265507283956789', '899c15b5a5504d1368f2eb7678322889'
end
