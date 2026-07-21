require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  test "restaurant exposes reservations through its tables" do
    restaurant = Restaurant.create!(name: "Test Restaurant", address: "123 Main St", phone: "+959123456789")
    table = restaurant.tables.create!(table_number: 1, capacity: 4, status: :available)
    reservation = table.reservations.create!(
      customer_name: "Ada Lovelace",
      phone: "+959123456789",
      guest_count: 2,
      reserved_at: Time.current + 1.day,
      status: :pending
    )

    assert_includes restaurant.reservations, reservation
  end
end
