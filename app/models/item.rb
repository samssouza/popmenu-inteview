class Item < ApplicationRecord
  has_many :menus_items
  validates :name, presence: true, uniqueness: true
end
