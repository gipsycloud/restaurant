class OrderItem < ApplicationRecord
  belongs_to :order
  belongs_to :menu

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_unit_price
  before_save :calculate_subtotal

  private
  def set_unit_price
    self.unit_price = menu.price if menu.present?
  end

  def calculate_subtotal
    self.subtotal = quantity * unit_price
  end
end
