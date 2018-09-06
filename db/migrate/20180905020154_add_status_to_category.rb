class AddStatusToCategory < ActiveRecord::Migration[5.2]
  def change
    add_column :categories, :status, :string
  end
end
