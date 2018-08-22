class Auction < ApplicationRecord
  belongs_to :timer
  has_many :auction_details, dependent: :destroy
  scope :auction_timer, ->(timer_id) { where timer_id: timer_id }
end
