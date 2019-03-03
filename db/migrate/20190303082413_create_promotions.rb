class CreatePromotions < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.integer :discount
      t.string :description
      t.text :detail
      t.references :user, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
