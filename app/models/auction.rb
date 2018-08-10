class Auction < ApplicationRecord
  belongs_to :product
  has_many :auction_details, dependent: :destroy
end
