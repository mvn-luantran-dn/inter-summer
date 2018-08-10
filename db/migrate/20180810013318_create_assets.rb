class CreateAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :assets do |t|
      t.string :file
      t.string :file_name
      t.integer :module_id
      t.string :module_type

      t.timestamps
    end
    add_index :assets, :module_id
    add_index :assets, :module_type
  end
end
