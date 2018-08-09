# frozen_string_literal: true

class CreateAutionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :aution_details do |t|
      t.references :aution, foreign_key: true
      t.references :user, foreign_key: true
      t.string :price_bid

      t.timestamps
    end
  end
end
