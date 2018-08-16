class Timer < ApplicationRecord
  belongs_to :product
  has_many :autions

  validates :start_at, presence: true
  validates :end_at, presence: true, after: :start_at
  validates :period, presence: true
  validates :bid_step, presence: true
  validates :status, presence: true
end
