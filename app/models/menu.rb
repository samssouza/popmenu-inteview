class Menu < ApplicationRecord
  has_many :menus_items, dependent: :destroy
  validates :name, presence: true, uniqueness: true
end
