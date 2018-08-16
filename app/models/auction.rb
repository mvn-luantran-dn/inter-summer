class Auction < ApplicationRecord
  belongs_to :timer
  has_many :auction_details, dependent: :destroy
end
