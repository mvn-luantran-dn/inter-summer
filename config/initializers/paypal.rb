require 'paypal/express'
PAYPAL_CONFIG = YAML::load(ERB.new(File.read("#{Rails.root}/config/paypal.yml")).result)[Rails.env].symbolize_keys
Paypal.sandbox! if PAYPAL_CONFIG[:sandbox]
