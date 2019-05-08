# == Schema Information
#
# Table name: timers
#
#  id         :bigint(8)        not null, primary key
#  product_id :bigint(8)
#  start_at   :time
#  end_at     :time
#  period     :time
#  bid_step   :integer
#  deleted_at :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  is_running :boolean          default(TRUE)
#

class Timer < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  before_destroy :delete_redis
  belongs_to :product
  has_many :auctions, dependent: :destroy

  validates :start_at, presence: true
  validates_time :start_at, between: ['8:00am', '11:00pm']
  validates :end_at, presence: true, after: :start_at
  validates_time :end_at, between: ['8:00am', '11:00pm']
  validates :period, presence: true
  validates :bid_step, presence: true

  def delete_redis
    $redis.del(self.id)
  end
end
