class Timer < ApplicationRecord
  belongs_to :product
  has_many :autions

  validates :start_at, presence: true
  validates :period, presence: true
  validates :bid_step, presence: true
  validates :status, presence: true
  validate :time_validation

  def time_validation
    if self[:end_at] < self[:start_at]
      errors[:time_validation] << "End_at must great than start_at"
      return false
    else
      return true
    end
  end
end
