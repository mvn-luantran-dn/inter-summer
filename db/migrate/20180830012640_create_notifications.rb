class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.string :content
      t.references :user, foreign_key: true
      t.integer :status
      t.integer :timer_id

      t.timestamps
    end
  end
end
