# == Schema Information
#
# Table name: products
#
#  id          :bigint(8)        not null, primary key
#  category_id :bigint(8)
#  name        :string
#  detail      :text
#  price       :integer
#  quantity    :integer
#  price_at    :integer
#  status      :string
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  color       :string
#  size        :string
#  material    :string
#  weight      :string
#

require 'csv'
class Product < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  belongs_to :category
  has_many :timers, dependent: :destroy
  has_many :assets, as: :module, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true
  has_many :items, dependent: :destroy
  validates :name, presence: true, length: { maximum: 100 }
  validates :detail, presence: true
  validates :quantity, presence: true
  validates :price, presence: true
  validates :price_at, presence: true
  validates :assets, length: { minimum: 1, maximum: 4 }
  scope :search_product, ->(content) do
    joins(:category).where('products.name LIKE ? or categories.name LIKE ? or products.price = ?',
                           "%#{content}%", "%#{content}%", content.to_s.to_i)
  end

  scope :common_order, -> { order('id DESC') }
  scope :include_basic, -> { includes(:assets) }

  def change_status_to_sale
    self.update_attribute(:status, ProductStatus::SELLING)
  end

  def change_status_to_unsale
    self.update_attribute(:status, ProductStatus::UNSELLING)
  end
end
