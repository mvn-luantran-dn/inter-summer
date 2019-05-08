class AddColumnToOrder < ActiveRecord::Migration[5.2]
  def change
    remove_column :orders, :type_payment
    add_column    :orders, :payment_id, :integer, foreign_key: true, null: false

    add_index :orders, :payment_id
  end
end
