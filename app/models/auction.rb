class Auction < ApplicationRecord
  belongs_to :timer
  has_many :auction_details, dependent: :destroy
  scope :auction_timer, ->(timer_id) { where timer_id: timer_id }
  scope :search, ->(content, start_time, end_time) do
    joins(timer: [:product]).where('products.name LIKE ? or auctions.created_at BETWEEN ? AND ?',
                                   "%#{content}%", start_time, end_time)
  end
end
