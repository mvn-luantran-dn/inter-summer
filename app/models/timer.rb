class Timer < ApplicationRecord
  before_destroy :delete_redis
  belongs_to :product
  has_many :auctions, dependent: :destroy

  validates :start_at, presence: true
  validates_time :start_at, between: ['8:00am', '11:00pm']
  validates :end_at, presence: true, after: :start_at
  validates_time :end_at, between: ['8:00am', '11:00pm']
  validates :period, presence: true
  validates :bid_step, presence: true
  validates :status, presence: true

  def delete_redis
    $redis.del(self.id)
  end
end
