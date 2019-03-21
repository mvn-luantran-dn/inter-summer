# == Schema Information
#
# Table name: auction_details
#
#  id         :bigint(8)        not null, primary key
#  auction_id :bigint(8)
#  user_id    :bigint(8)
#  price_bid  :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class AuctionDetail < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :auction
  belongs_to :user

  validates :price_bid, presence: true
end
