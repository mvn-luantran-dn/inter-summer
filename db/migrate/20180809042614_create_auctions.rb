# frozen_string_literal: true

class CreateAuctions < ActiveRecord::Migration[5.2]
  def change
    create_table :auctions do |t|
      t.references :product
      t.datetime :start_at
      t.integer :period
      t.integer :bid_step

      t.timestamps
    end
  end
end
