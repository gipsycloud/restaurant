require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "walk-in orders can be created without a reservation" do
    restaurant = Restaurant.create!(name: "Test Restaurant", address: "123 Main St", phone: "+959123456789")
    table = restaurant.tables.create!(table_number: 1, capacity: 4, status: :available)
    order = Order.new(table: table, status: :pending, payment_status: :unpaid, total_amount: 0)

    assert order.valid?
    assert_nothing_raised { order.save! }
  end
end
