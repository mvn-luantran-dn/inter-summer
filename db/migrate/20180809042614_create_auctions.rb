class CreateAuctions < ActiveRecord::Migration[5.2]
  def change
    create_table :auctions do |t|
      t.references :timer, foreign_key: true
      t.string :status
      t.datetime :deleted_at
      
      t.timestamps
    end
  end
end
