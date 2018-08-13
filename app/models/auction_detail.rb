# frozen_string_literal: true

class AuctionDetail < ApplicationRecord
  belongs_to :auction
  belongs_to :user

  validates :price_bid, presence: true
end
