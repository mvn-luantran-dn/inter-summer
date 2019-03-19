class AuctionDetail < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :auction
  belongs_to :user

  validates :price_bid, presence: true
end
