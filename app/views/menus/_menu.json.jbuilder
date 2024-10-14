json.extract! menu, :id, :name, :created_at, :updated_at
json.menu_items @menu.menus_items do |menu_item|
  json.id menu_item.id
  json.name menu_item.item.name
  json.price menu_item.price
  json.url menus_item_url(menu_item, format: :json)
end
json.url menu_url(menu, format: :json)
