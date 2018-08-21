class CreateTimers < ActiveRecord::Migration[5.2]
  def change
    create_table :timers do |t|
      t.references :product, foreign_key: true
      t.time :start_at
      t.time :end_at
      t.time :period
      t.integer :bid_step
      t.string :status

      t.timestamps
    end
  end
end
