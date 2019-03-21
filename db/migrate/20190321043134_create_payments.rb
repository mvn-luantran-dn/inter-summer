class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.string :name, null: false
      t.string :description
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
