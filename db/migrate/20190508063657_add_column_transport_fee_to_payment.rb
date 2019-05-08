class AddColumnTransportFeeToPayment < ActiveRecord::Migration[5.2]
  def change
    add_column :payments, :transport_fee, :integer
  end
end
