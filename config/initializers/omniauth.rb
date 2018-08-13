Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '296978280429-rl6jdsfjoar8msrvja2e6ulbefnmir8d.apps.googleusercontent.com', 'FCweqPcpQyWGIPFbbIdTBucL'
  provider :facebook, '265507283956789', '899c15b5a5504d1368f2eb7678322889'
end
