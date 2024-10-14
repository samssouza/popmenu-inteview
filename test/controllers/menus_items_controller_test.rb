require "test_helper"

class MenusItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menus_item = menus_items(:lunch_burger)
  end

  test "should get index" do
    get menus_items_url
    assert_response :success
  end

  test "should get new" do
    get new_menus_item_url
    assert_response :success
  end

  test "should create menus_item" do
    assert_difference("MenusItem.count") do
      post menus_items_url, params: { menus_item: { item_id: items(:fries).id, menu_id: @menus_item.menu_id } }
    end

    assert_redirected_to menus_item_url(MenusItem.last)
  end

  test "should show menus_item" do
    get menus_item_url(@menus_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_menus_item_url(@menus_item)
    assert_response :success
  end

  test "should update menus_item" do
    patch menus_item_url(@menus_item), params: { menus_item: { item_id: items(:fries).id, menu_id: @menus_item.menu_id } }
    assert_redirected_to menus_item_url(@menus_item)
  end

  test "should destroy menus_item" do
    assert_difference("MenusItem.count", -1) do
      delete menus_item_url(@menus_item)
    end

    assert_redirected_to menus_items_url
  end
end
