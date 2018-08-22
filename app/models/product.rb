class Product < ApplicationRecord
  belongs_to :category
  has_many :timers, dependent: :destroy
  has_many :assets, as: :module, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true
  has_many :item
  validates :name, presence: true, length: { maximum: 100 }
  validates :detail, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :price_at, presence: true
  validates :assets, length: { minimum: 1, maximum: 4 }

  def change_status_to_sale
    self.update_attribute(:status, ProductStatus::SELLING)
  end

  def change_status_to_unsale
    self.update_attribute(:status, ProductStatus::UNSELLING)
  end
end
