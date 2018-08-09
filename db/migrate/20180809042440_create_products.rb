# frozen_string_literal: true

class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :category, foreign_key: true
      t.string :name
      t.string :detail
      t.integer :price
      t.datetime :start_at
      t.datetime :end_at
      t.integer :period
      t.integer :step
      t.string :status
      t.integer :price_at

      t.timestamps
    end
  end
end
