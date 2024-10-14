class Menu < ApplicationRecord
  has_many :menus_items, dependent: :destroy
  validates :name, presence: true, uniqueness: true
  accepts_nested_attributes_for :menus_items, allow_destroy: true
end
