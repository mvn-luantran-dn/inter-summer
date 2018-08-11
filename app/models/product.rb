class Product < ApplicationRecord
  belongs_to :category
  has_many :assets, as: :module, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true
  has_many :item
  validates :name, presence: true, length: { maximum: 100 }
  validates :detail, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :price_at, presence: true
end
