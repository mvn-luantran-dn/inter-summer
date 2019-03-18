class AddDefaultValueToGenderOfUser < ActiveRecord::Migration[5.2]
  def up
    change_column :users, :gender, :integer, default: 1, null: false
  end

  def down
    change_column :users, :gender, :integer, default: nil
  end
end
