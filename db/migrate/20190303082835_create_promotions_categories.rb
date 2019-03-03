class CreatePromotionsCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :promotions_categories do |t|
      t.references :category, foreign_key: true
      t.references :promotion, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
