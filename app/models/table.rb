class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :reservations, dependent: :destroy
  has_many :orders, dependent: :destroy

  validates :table_number, presence: true, uniqueness: { scope: :restaurant_id }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  enum status: { available: 0, occupied: 1, reserved: 2 }
end
