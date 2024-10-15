json.extract! restaurant, :id, :name, :created_at, :updated_at

json.menus restaurant.menus do |menu|
  json.extract! menu, :id, :name, :created_at, :updated_at

  json.menu_items menu.menus_items do |menu_item|
    json.extract! menu_item, :id, :price, :created_at, :updated_at

    json.item do
      json.extract! menu_item.item, :id, :name, :created_at, :updated_at
    end
  end
end
json.url restaurant_url(restaurant, format: :json)
