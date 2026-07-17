class Order < ApplicationRecord
  belongs_to :table
  belongs_to :reservation
  has_many :order_items, dependent: :destroy
  has_many :menus, through: :order_items
  has_one :payment, dependent: :destroy
  has_one :receipt, dependent: :destroy

  validates :status: presence: true
  validated :total_amount, numericality: { greather_than_or_equal_to: 0 }

  enum status: { pending: 0, confirmed: 1, preparing: 2, ready: 3, completed: 4, cancelled: 5 }
  enum payment_status: { unpaid: 0, paid: 1, refunde: 2 }

  def calculate_total!
    total = order_items.sum(:subtotal)
    update!(total_amount: total )
  end
end
