require "test_helper"

class ItemTest < ActiveSupport::TestCase
  test "should not save item without name" do
    item = Item.new
    assert_not item.save, "Saved the item without a name"
  end

  test "should not save item with duplicate name" do
    item = Item.new(name: items(:burger).name)
    assert_not item.save, "Saved the item with a duplicate name"
  end

  test "should save valid item" do
    item = Item.new(name: "Cake")
    assert item.save, "Could not save a valid item"
  end

  test "should correctly update item" do
    assert items(:burger).update(name: "Cheeseburger"), "Failed to update item"
    assert_equal "Cheeseburger", items(:burger).reload.name
  end

  test "should raise error when deleting item that is in use" do
    assert_raises(ActiveRecord::InvalidForeignKey) do
      items(:burger).destroy
    end
    assert Item.exists?(items(:burger).id), "Item was deleted from the database despite being referenced"
  end

  test "should be ablee to delete item that is not in use" do
    unused_item = Item.create(name: "Unused Item")
    assert unused_item.destroy, "Failed to delete unused item"
    assert_not Item.exists?(unused_item.id), "Unused item was not deleted from the database"
  end
end
