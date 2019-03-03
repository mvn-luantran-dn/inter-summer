class CreateAuctionDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :auction_details do |t|
      t.references :auction, foreign_key: true
      t.references :user, foreign_key: true
      t.integer :price_bid
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
