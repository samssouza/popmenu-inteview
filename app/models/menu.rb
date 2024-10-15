class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menus_items, dependent: :destroy
  has_many :items, through: :menus_items
  accepts_nested_attributes_for :menus_items, allow_destroy: true
  validates_uniqueness_of :name, scope: :restaurant_id
end
