class AddColumnToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :status, :boolean
    add_column :users, :root, :boolean, default: false
    add_column :users, :deactivated_at, :datetime
  end
end
