class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :childcategories, class_name: Category.name,
                             foreign_key: :parent_id,
                             dependent: :destroy,
                             inverse_of: false
  validates :name, presence: true, length: { maximum: 100 }
  scope :get_without_self, ->(id) { where.not(id: id) }
  scope :get_without_parent_self, ->(parent_id) { where.not(parent_id: parent_id) }
  scope :search_name, ->(content) { where 'name LIKE ?', "%#{content}%" }
end
