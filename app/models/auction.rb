class Auction < ApplicationRecord
  belongs_to :product
  has_many :auction_details, dependent: :destroy

  validates :start_at, presence: true
  validates :period, presence: true
  validates :bid_step, presence: true
end
