class Item < ApplicationRecord
  #NOTE: purposely leaves out dependent: :destroy to avoid cascading deletes
  #NOTE: database constraints will prevent deletion of items that are in use
  has_many :menus_items
  has_many :menus, through: :menus_items
  validates :name, presence: true, uniqueness: true
end
