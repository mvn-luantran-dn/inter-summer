class AddColumnToProduct < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :color, :string
    add_column :products, :size, :string
  end
end
