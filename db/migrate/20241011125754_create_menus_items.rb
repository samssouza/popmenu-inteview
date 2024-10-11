class CreateMenusItems < ActiveRecord::Migration[7.1]
  def change
    create_table :menus_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.references :item, null: false, foreign_key: true
      t.decimal :price
      t.index [:menu_id, :item_id], unique: true

      t.timestamps
    end
  end
end
