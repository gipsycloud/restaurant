class Table < ApplicationRecord
  belongs_to :restaurant
  has_many :reservations, dependent: :destroy
  has_many :orders, dependent: :destroy

  before_validation :set_default_status, on: :create

  validates :table_number, presence: true, uniqueness: { scope: :restaurant_id }
  validates :capacity, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true
  enum status: { available: "available", occupied: "occupied", reserved: "reserved" }

  private

  def set_default_status
    self.status ||= :available
  end
end
