class Restaurant < ApplicationRecord
  has_many :menus, dependent: :destroy
  accepts_nested_attributes_for :menus, allow_destroy: true
  validates :name, presence: true
  validates_uniqueness_of :name
end
