class Timer < ApplicationRecord
  before_destroy :delete_redis
  belongs_to :product
  has_many :auctions, dependent: :destroy

  validates :start_at, presence: true
  validates :end_at, presence: true, after: :start_at
  validates :period, presence: true
  validates :bid_step, presence: true
  validates :status, presence: true

  def delete_redis
    $redis.del(self.id)
  end
end
