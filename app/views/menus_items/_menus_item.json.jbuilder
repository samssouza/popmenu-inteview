json.extract! menus_item, :id, :item_id, :menu_id, :created_at, :updated_at
json.item menus_item.item.name
json.menu menus_item.menu.name
json.url menus_item_url(menus_item, format: :json)
