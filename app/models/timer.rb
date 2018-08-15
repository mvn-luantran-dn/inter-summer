class Timer < ApplicationRecord
  validates_with TimersValidator

  belongs_to :product
  has_many :autions

  validates :start_at, presence: true
  validates :period, presence: true
  validates :bid_step, presence: true
  validates :status, presence: true
end