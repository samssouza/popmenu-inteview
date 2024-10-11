require "test_helper"

class MenusItemTest < ActiveSupport::TestCase
  test "should allow changing menu item's item" do
    menu_item = menus_items(:lunch_burger)
    menu_item.item = items(:fries)

    assert menu_item.save, "Could not change menu item's item"
    assert_equal items(:fries), menu_item.reload.item, "Menu item's item was not changed"
  end

  test "should not allow changing to an item that already exists in the menu" do
    lunch_burger = menus_items(:lunch_burger)
    lunch_burger.item = items(:salad)
    assert_not lunch_burger.save
    assert_includes lunch_burger.errors.messages[:item_id], "already exists in this menu"
  end

  test "destroying a menu should destroy all associated menu items" do
    menu = menus(:lunch)
    menu_item_ids = menu.menus_items.pluck(:id)

    assert_difference 'MenusItem.count', -menu_item_ids.count do
      menu.destroy
    end

    assert_empty MenusItem.where(id: menu_item_ids), "Menu items were not destroyed with the menu"
  end

  test "should not save menu_item without menu" do
    menu_item = MenusItem.new(item: items(:burger), price: 9.99)
    assert_not menu_item.save, "Saved the menu_item without a menu"
  end

  test "should not save menu_item without item" do
    menu_item = MenusItem.new(menu: menus(:lunch), price: 9.99)
    assert_not menu_item.save, "Saved the menu_item without an item"
  end

  test "should not save menu_item without price" do
    menu_item = MenusItem.new(menu: menus(:lunch), item: items(:burger))
    assert_not menu_item.save, "Saved the menu_item without a price"
  end

  test "should save valid menu_item" do
    menu_item = MenusItem.new(menu: menus(:dinner), item: items(:burger), price: 12.99)
    assert menu_item.save, "Could not save a valid menu_item"
  end

  test "should belong to menu" do
    assert_respond_to menus_items(:lunch_burger), :menu
  end

  test "should belong to item" do
    assert_respond_to menus_items(:lunch_burger), :item
  end

  test "should not allow duplicate items in the same menu" do
    existing_menu_item = menus_items(:lunch_burger)
    duplicate_menu_item = MenusItem.new(
      menu: existing_menu_item.menu,
      item: existing_menu_item.item,
    )

    assert_not duplicate_menu_item.save
    assert_includes duplicate_menu_item.errors.messages[:item_id], "already exists in this menu"
  end

  test "should allow the same item in different menus" do
    existing_menu_item = menus_items(:lunch_burger)
    different_menu_item = MenusItem.new(
      menu: menus(:dinner),
      item: existing_menu_item.item,
      price: 14.99
    )
    assert different_menu_item.save, "Could not save the same item in a different menu"
  end
end
