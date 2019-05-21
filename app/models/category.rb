# == Schema Information
#
# Table name: categories
#
#  id          :bigint(8)        not null, primary key
#  name        :string
#  parent_id   :integer
#  deleted_at  :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :string
#

class Category < ApplicationRecord
  acts_as_paranoid
  strip_attributes

  has_many :promotions_categories, -> {}, dependent: :destroy
  has_many :products, dependent: :destroy
  has_many :child_categories, class_name: Category.name,
                              foreign_key: :parent_id,
                              dependent: :destroy,
                              inverse_of: false
  belongs_to :parent_category, class_name: Category.name,
                               foreign_key: :parent_id,
                               optional: true
  has_one :asset, as: :module, dependent: :destroy
  validates :name, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 100 }
  validate :can_not_greater_than_two_level

  scope :get_without_self, ->(id) { where.not(id: id) }
  scope :search_name, ->(content) { where 'name LIKE ?', "%#{content}%" }
  scope :include_basic, -> { includes(:asset, :parent_category, :child_categories) }
  scope :root, -> { where(parent_id: nil) }
  scope :common_order, -> { order(id: :desc) }

  def self.import_file(file)
    spreadsheet = Roo::Spreadsheet.open file
    header = spreadsheet.row(1)
    rows = []
    (2..spreadsheet.last_row).each do |i|
      rows << spreadsheet.row(i)
    end
    import! header, rows
  end

  private

    def can_not_greater_than_two_level
      category = Category.find_by(id: parent_id)
      return if category.nil?
      return if category.parent_category.blank?

      errors.add(:parent_id, I18n.t('categories.errors.can_not_two_level'))
    end
end
