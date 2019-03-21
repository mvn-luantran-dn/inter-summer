class ChangeColumnTableOrder < ActiveRecord::Migration[5.2]
  def up
    change_column :orders, :status, :string, default: 'waitting', null: false
  end

  def down
    change_column :orders, :status, :integer
  end
end
