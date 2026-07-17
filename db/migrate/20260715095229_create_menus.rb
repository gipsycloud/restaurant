class CreateMenus < ActiveRecord::Migration[7.0]
  def change
    create_table :menus do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.string :name
      t.text :description
      t.string :category
      t.decimal :price
      t.boolean :is_available

      t.timestamps
    end
  end
end
