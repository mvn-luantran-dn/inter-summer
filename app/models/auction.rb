# == Schema Information
#
# Table name: auctions
#
#  id         :bigint(8)        not null, primary key
#  timer_id   :bigint(8)
#  status     :string
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Auction < ApplicationRecord
  belongs_to :timer
  has_many :auction_details, dependent: :destroy
  scope :auction_timer, ->(timer_id) { where timer_id: timer_id }
  scope :search, ->(content, start_time, end_time) do
    joins(timer: [:product]).where('products.name LIKE ? or auctions.created_at BETWEEN ? AND ?',
                                   "%#{content}%", start_time, end_time)
  end

  scope :common_order, -> { order('id DESC') }
end
