class AddTypePaymentToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :type_payment, :string
  end
end
