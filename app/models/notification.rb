class Notification < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :user
end
