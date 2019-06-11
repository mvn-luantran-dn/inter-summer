class AddColumnToOrderPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :transaction_id, :string
    add_column :orders, :token, :string
    add_column :orders, :canceled, :boolean, default: false
    add_column :orders, :payer_id, :string
    add_column :orders, :expires_at, :datetime
    add_column :orders, :purchased_at, :datetime
  end
end
