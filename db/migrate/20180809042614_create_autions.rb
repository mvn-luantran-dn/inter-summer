class CreateAutions < ActiveRecord::Migration[5.2]
  def change
    create_table :autions do |t|
      t.references :product
      t.string :status

      t.timestamps
    end
  end
end
