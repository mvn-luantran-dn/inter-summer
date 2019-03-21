class ChangeColumnAsset < ActiveRecord::Migration[5.2]
  def up
    rename_column :assets, :file_name, :name
  end

  def down
    change_column :assets, :name, :file_name
  end
end
