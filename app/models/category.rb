class Category < ApplicationRecord
  acts_as_paranoid

  has_many :products, dependent: :destroy
  has_many :child_categories, class_name: Category.name,
                             foreign_key: :parent_id,
                             dependent: :destroy,
                             inverse_of: false
  belongs_to :parent_category, class_name: Category.name,
                           foreign_key: :parent_id,
                           optional: true
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }
  validate :can_not_greater_than_two_level

  scope :get_without_self, ->(id) { where.not(id: id) }
  scope :get_without_parent_self, ->(parent_id) { where.not(parent_id: parent_id) }
  scope :search_name, ->(content) { where 'name LIKE ?', "%#{content}%" }
  scope :include_basic, -> { includes(:parent_category, :child_categories) }
  scope :root, -> { where(parent_id: nil) }

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
      binding.pry
      category = Category.find_by(id: parent_id)
      return if category.nil?
      return if category.parent_category.blank?

      errors.add :parent_id, I18n.t('categories.can_not_two_level')
    end
end
