class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :order_items, dependent: :destroy

  validates :name, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :category, presence: true

  scope :available, -> { where(is_available: true) }
  scope :by_category, ->(category) { where(category: category) }
end
