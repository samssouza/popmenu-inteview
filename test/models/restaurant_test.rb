require "test_helper"

class RestaurantTest < ActiveSupport::TestCase

  test "can create a restaurant" do
    assert_difference 'Restaurant.count', 1 do
      Restaurant.create(name: "New Restaurant")
    end

    new_restaurant = Restaurant.last
    assert_equal "New Restaurant", new_restaurant.name
  end

  test "cannot create a restaurant without a name" do
    restaurant = Restaurant.new
    assert_not restaurant.valid?
    assert_includes restaurant.errors[:name], "can't be blank"
  end

  test "can read a restaurant" do
    restaurant = restaurants(:popos)
    assert_equal "Poppo's Cafe", restaurant.name
  end

  test "can update a restaurant" do
    restaurant = restaurants(:popos)
    restaurant.update(name: "Updated Poppo's")
    assert_equal "Updated Poppo's", restaurant.reload.name
  end


  test "destroying a restaurant should destroy associated menus" do
    restaurant = restaurants(:popos)
    assert_difference 'Menu.count', -2 do
      restaurant.destroy
    end
  end

  test "restaurant name should be unique" do
    restaurant = Restaurant.new(name: "Poppo's Cafe")
    assert_not restaurant.valid?
    assert_includes restaurant.errors[:name], "has already been taken"
  end

  test "restaurant can have multiple menus" do
    restaurant = restaurants(:popos)
    assert_equal 2, restaurant.menus.count
    assert_includes restaurant.menus, menus(:lunch)
    assert_includes restaurant.menus, menus(:dinner)
  end

  test "can create restaurant with nested menus" do
    restaurant_params = {
      name: "New Restaurant",
      menus_attributes: [
        { name: "Breakfast" },
        { name: "Lunch" }
      ]
    }

    assert_difference ['Restaurant.count'], 1 do
      assert_difference ['Menu.count'], 2 do
        r = Restaurant.create(restaurant_params)
      end
    end

    new_restaurant = Restaurant.last
    assert_equal "New Restaurant", new_restaurant.name
    assert_equal 2, new_restaurant.menus.count
    assert_equal ["Breakfast", "Lunch"], new_restaurant.menus.pluck(:name)
  end

  test "can update restaurant nested menus" do
    restaurant = restaurants(:popos)

    update_params = {
      menus_attributes: [
        { id: menus(:lunch).id, name: "Brunch" },
      ]
    }

    assert_difference 'Menu.count', 0 do
      restaurant.update(update_params)
    end

    restaurant.reload
    assert_includes restaurant.menus.pluck(:name), "Brunch"
  end

  test "can destroy nested menu through restaurant update" do
    restaurant = restaurants(:popos)
    lunch_menu_id = menus(:lunch).id

    update_params = {
      menus_attributes: [
        { id: lunch_menu_id, _destroy: '1' }
      ]
    }

    assert_difference 'Menu.count', -1 do
      restaurant.update(update_params)
    end

    restaurant.reload
    assert_equal 1, restaurant.menus.count
    assert_not_includes restaurant.menus.pluck(:id), lunch_menu_id
  end


end
