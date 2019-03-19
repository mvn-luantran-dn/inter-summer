class Item < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :order
  belongs_to :product
end
