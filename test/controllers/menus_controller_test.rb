require "test_helper"

class MenusControllerTest < ActionDispatch::IntegrationTest
  setup do
    @menu = menus(:lunch)
  end

  test "should get index" do
    get menus_url
    assert_response :success
  end

  test "should get new" do
    get new_menu_url
    assert_response :success
  end

  test "should create menu" do
    assert_difference("Menu.count") do
      post menus_url, params: { menu: { name: 'New menu' } }
    end

    assert_redirected_to menu_url(Menu.last)
  end

  test "should show menu" do
    get menu_url(@menu)
    assert_response :success
  end

  test "should get edit" do
    get edit_menu_url(@menu)
    assert_response :success
  end

  test "should update menu" do
    patch menu_url(@menu), params: { menu: { name: 'Updated Name' } }
    assert_redirected_to menu_url(@menu)
  end

  test "should be able to create items thorug menu" do
    patch menu_url(@menu), params: { menu: { name: 'Updated Name' } }
    assert_redirected_to menu_url(@menu)
  end

  test "should destroy menu" do
    assert_difference("Menu.count", -1) do
      delete menu_url(@menu)
    end

    assert_redirected_to menus_url
  end

  #NOTE: Nested fields validations
  test "should create menu with items" do
    salad = items(:salad)
    steak = items(:steak)
    assert_difference('Menu.count') do
      assert_difference('MenusItem.count', 2) do
        post menus_url, params: {
          menu: {
            name: 'New Menu',
            menus_items_attributes: [
              { item_id: salad.id, price: 9.99 },
              { item_id: steak.id, price: 14.99 }
            ]
          }
        }, as: :json
      end
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal 'New Menu', json_response['name']
    assert_equal 2, json_response['menu_items'].length
    assert_equal 'Salad', json_response['menu_items'][0]['name']
    assert_equal 'Steak', json_response['menu_items'][1]['name']
  end

  test "should update menu item through menu" do
    fries_id = items(:fries).id
    lunch_salad_id = menus_items(:lunch_salad).id

    assert_no_difference 'MenusItem.count' do
      patch menu_url(@menu), params: {
        menu: {
          menus_items_attributes: [
            { id: lunch_salad_id, item_id: fries_id, price: 10.99 }
          ]
        }
      }, as: :json
    end
    assert_response :success

    json_response = JSON.parse(response.body)
    assert json_response['menu_items'].any? { |item| item['name'] == 'Fries' }
  end

  test "should remove item associations" do
    @menu_item = menus_items(:lunch_salad)

    assert_difference('MenusItem.count', -1) do
      patch menu_url(@menu), params: {
        menu: {
          menus_items_attributes: [
            { id: @menu_item.id, _destroy: '1' }
          ]
        }
      }, as: :json
    end
    assert_response :success

    json_response = JSON.parse(response.body)
    salad_item = json_response['menu_items'].find { |item| item['name'] == 'Salad' }
    assert_nil salad_item, "Salad item should be present in the menu"
  end

end
