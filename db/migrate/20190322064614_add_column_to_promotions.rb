class AddColumnToPromotions < ActiveRecord::Migration[5.2]
  def change
    add_column :promotions, :name, :string, null: false
  end
end
