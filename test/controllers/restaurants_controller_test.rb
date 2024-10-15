require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @restaurant = restaurants(:popos)
  end

  test "should get index" do
    get restaurants_url
    assert_response :success
  end

  test "should get new" do
    get new_restaurant_url
    assert_response :success
  end

  test "should create restaurant" do
    assert_difference("Restaurant.count") do
      post restaurants_url, params: { restaurant: { name: 'New Restaurant' } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)
  end

  test "should show restaurant" do
    get restaurant_url(@restaurant)
    assert_response :success
  end

  test "should get edit" do
    get edit_restaurant_url(@restaurant)
    assert_response :success
  end

  test "should update restaurant" do
    patch restaurant_url(@restaurant), params: { restaurant: { name: @restaurant.name } }
    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should destroy restaurant" do
    assert_difference("Restaurant.count", -1) do
      delete restaurant_url(@restaurant)
    end

    assert_redirected_to restaurants_url
  end

  test "should create restaurant with nested menus and items" do
    assert_difference(-> { Restaurant.count } => 1, -> { Menu.count } => 2, -> { MenusItem.count } => 3) do
      post restaurants_url, params: { restaurant: {
        name: "New Restaurant",
        menus_attributes: [
          {
            name: "Lunch",
            menus_items_attributes: [
              { item_id: items(:burger).id, price: 10.99 },
              { item_id:  items(:steak).id, price: 8.99 }
            ]
          },
          {
            name: "Dinner",
            menus_items_attributes: [
              { item_id: items(:salad).id, price: 24.99 }
            ]
          }
        ]
      } }
    end

    assert_redirected_to restaurant_url(Restaurant.last)

    restaurant = Restaurant.last
    assert_equal "New Restaurant", restaurant.name
    assert_equal 2, restaurant.menus.count
    assert_equal 3, restaurant.menus.map(&:menus_items).flatten.count
  end

  test "should destroy menu" do
    assert_difference('Menu.count', -1) do
      patch restaurant_url(@restaurant, params: {
        restaurant: {
          menus_attributes: [
            { id: @restaurant.menus.first.id, _destroy: '1' }
          ]
        }
      })
    end

    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should update existing restaurant menu item" do
    menu_item = @restaurant.menus.first.menus_items.first
    new_price = 10.99

    patch restaurant_url(@restaurant, params: {
      restaurant: {
        menus_attributes: [
          {
            id: menu_item.menu.id,
            menus_items_attributes: [
              { id: menu_item.id, price: new_price }
            ]
          }
        ]
      }
    })

    assert_redirected_to restaurant_url(@restaurant)
    assert_equal new_price, menu_item.reload.price
  end

  test "should remove menu item from menu" do
    menu = @restaurant.menus.first
    menu_item = menu.menus_items.first

    assert_difference('MenusItem.count', -1) do
      patch restaurant_url(@restaurant, params: {
        restaurant: {
          menus_attributes: [
            {
              id: menu.id,
              menus_items_attributes: [
                { id: menu_item.id, _destroy: '1' }
              ]
            }
          ]
        }
      })
    end

    assert_redirected_to restaurant_url(@restaurant)
  end

  test "should add a menu item to existing menu" do
    menu = @restaurant.menus.first
    new_item = items(:puppuccino)

    assert_difference('MenusItem.count', 1) do
      patch restaurant_url(@restaurant, params: {
        restaurant: {
          menus_attributes: [
            {
              id: menu.id,
              menus_items_attributes: [
                { item_id: new_item.id, price: 5.99 }
              ]
            }
          ]
        }
      })
    end

    assert_redirected_to restaurant_url(@restaurant)
    assert menu.reload.items.include?(new_item)
  end

  test "should create new menu in existing restaurant" do
    assert_difference('Menu.count', 1) do
      patch restaurant_url(@restaurant, params: {
        restaurant: {
          menus_attributes: [
            {
              name: 'Brunch',
              menus_items_attributes: [
                { item_id: items(:burger).id, price: 12.99 },
                { item_id: items(:puppuccino).id, price: 3.99 }
              ]
            }
          ]
        }
      })
    end

    assert_redirected_to restaurant_url(@restaurant)
    assert @restaurant.reload.menus.find_by(name: 'Brunch').present?
  end


  test "should import restaurants successfully" do
    assert_difference('ImportJob.count', 1) do
      assert_difference('Restaurant.count', 2) do
        post import_restaurants_url, params: {
          restaurants: [
            {
              name: "New Restaurant 1",
              menus: [
                {
                  name: "Lunch Menu",
                  menu_items: [
                    { name: "Burger", price: 10.99 },
                    { name: "Salad", price: 7.99 }
                  ]
                }
              ]
            },
            {
              name: "New Restaurant 2",
              menus: [
                {
                  name: "Dinner Menu",
                  menu_items: [
                    { name: "Steak", price: 25.99 },
                    { name: "Fish", price: 18.99 }
                  ]
                }
              ]
            }
          ]
        }, as: :json
      end
    end

    assert_response :created

    response_body = JSON.parse(response.body)
    assert_equal 'success', response_body['status']
    assert_equal 'Import completed successfully', response_body['message']

    import_job = ImportJob.last
    assert_equal 'completed', import_job.status
    assert_equal 12, import_job.import_logs.count # 2 restaurants + 2 menus + 4 menu items + 4 items
  end

end
