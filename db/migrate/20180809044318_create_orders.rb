class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.string :address
      t.string :phone
      t.string :name
      t.integer :total_price
      t.datetime :deleted_at
      t.integer :status
      
      t.timestamps
    end
  end
end
