class Reservation < ApplicationRecord
  belongs_to :table

  has_many :orders, dependent: :nullify

  validates :customer_name, presence: true
  validates :phone, presence: true
  validates :guest_count, presence: true, numericality: { greater_than: 0 }
  validetes :reserved_at, presence: true

  enum status: { pending: 0, confirmed: 1, cancelled: 2 }

  validate :table_availability
  validate :reservation_time
  private

  def table_availability
    return if errors.any?
    if guest_count > table.capacity
      errors.add(:guest_count, "exceeds table capacity")
    end
  end

  def reservation_time
    return if errors.any?
    if reserved_at < Time.current
      errors.add(:reserved_at, "must be in the future")
    end
  end
end