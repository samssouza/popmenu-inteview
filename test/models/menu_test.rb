require "test_helper"

class MenuTest < ActiveSupport::TestCase
  test "should not save menu without name" do
    menu = Menu.new
    assert_not menu.save, "Saved the menu without a name"
  end

  test "should not save menu with duplicate name" do
    menu = Menu.new(name: menus(:lunch).name)
    assert_not menu.save, "Saved the menu with a duplicate name"
  end

  test "should save valid menu" do
    menu = Menu.new(name: "Brunch", restaurant: restaurants(:popos))
    assert menu.save, "Could not save a valid menu"
  end

  test "should be able to update menu" do
    new_name = "Brunch Menu"
    assert menus(:lunch).update(name: new_name), "Failed to update menu"
    assert_equal new_name, menus(:lunch).reload.name
  end

  test "should destroy menu and its menu items" do
    menu_items_count = menus(:lunch).menus_items.count
    assert_difference 'Menu.count', -1 do
      assert_difference 'MenusItem.count', -menu_items_count do
        menus(:lunch).destroy
      end
    end
  end

end
