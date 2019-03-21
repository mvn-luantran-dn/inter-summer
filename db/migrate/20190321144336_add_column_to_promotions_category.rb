class AddColumnToPromotionsCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :promotions_categories, :discount, :integer, null: false
  end
end
