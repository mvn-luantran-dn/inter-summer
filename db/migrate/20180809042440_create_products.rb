# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :category, foreign_key: true
      t.string :name
      t.string :detail
      t.integer :price
      t.integer :quantity
      t.integer :price_at
      t.string :status

      t.timestamps
    end
  end
end
