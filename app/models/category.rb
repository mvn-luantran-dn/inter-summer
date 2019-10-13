class Category < ApplicationRecord
  has_many :products, dependent: :destroy
  has_many :childcategories, class_name: Category.name,
                             foreign_key: :parent_id,
                             dependent: :destroy,
                             inverse_of: false
  validates :name, presence: true, uniqueness: true, length: { maximum: 100 }

  scope :get_without_self, ->(id) { where.not(id: id) }
  scope :get_without_parent_self, ->(parent_id) { where.not(parent_id: parent_id) }
  scope :search_name, ->(content) { where 'name LIKE ?', "%#{content}%" }

  def self.import_file(file)
    spreadsheet = Roo::Spreadsheet.open file
    header = spreadsheet.row(1)
    rows = []
    (2..spreadsheet.last_row).each do |i|
      rows << spreadsheet.row(i)
    end
    import! header, rows
  end
end
