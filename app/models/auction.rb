class Auction < ApplicationRecord
  validates :start_at, presence: true
  validates :period, presence: true
  validates :bid_step, presence: true
end
