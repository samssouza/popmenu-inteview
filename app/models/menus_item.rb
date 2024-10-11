class MenusItem < ApplicationRecord
  belongs_to :menu
  belongs_to :item
  validates_uniqueness_of :item_id, scope: :menu_id, message: "already exists in this menu"
end
