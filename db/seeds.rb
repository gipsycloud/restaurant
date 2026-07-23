# db/seeds.rb
require 'faker'

# Helper method to generate valid Myanmar phone numbers for our validation
def myanmar_phone
  "+959#{Faker::Number.number(digits: 9)}"
end

# Helper to generate fake transaction IDs
def fake_txn_id
  "TXN#{Time.current.to_i}#{SecureRandom.hex(4).upcase}"
end

# Wrap in transaction so it all succeeds or all fails
ActiveRecord::Base.transaction do
  [Receipt, Payment, OrderItem, Order, Reservation, Menu, Table, User, Restaurant].each(&:destroy_all)
  items = ["Bistro", "Kitchen", "Cafe", "Dining", "House"]
  restaurants = 5.times.map do
    Restaurant.create!(
      name: "#{Faker::Company.name} #{items.sample}",
      address: "#{Faker::Address.street_address}, Yangon",
      phone: myanmar_phone
    )
  end

  restaurants.each do |rest|
    # 1 Admin per restaurant
    rest.users.create!(
      name: Faker::Name.name,
      email: Faker::Internet.unique.email(name: "admin_#{rest.id}"),
      role: "admin"
    )
    
    # 2 to 4 Staff per restaurant
    rand(2..4).times do
      rest.users.create!(
        name: Faker::Name.name,
        email: Faker::Internet.unique.email,
        role: "staff"
      )
    end
  end

  restaurants.each do |rest|
    rand(2..4).times do |i|
      rest.tables.create!(
        table_number: i + 1,
        capacity: [2, 4, 4, 4, 6, 8].sample,
        status: Table.statuses.keys.sample
      )
    end
  end

  categories = ["Appetizer", "Main Course", "Beverage", "Dessert", "Burmese Special"]
  restaurants.each do |rest|
    rand(10..15).times do
      rest.menus.create!(
        name: Faker::Food.dish,
        description: Faker::Food.description,
        category: categories.sample,
        price: Faker::Commerce.price(range: 1.5..30.0),
        is_available: [true, true, true, false].sample # 75% chance available
      )
    end
  end

  restaurants.each do |rest|
    available_tables = rest.tables.to_a
    available_menus = rest.menus.available.to_a
    
    # Create 40 to 60 orders per restaurant over the last 30 days
    rand(10..15).times do
      table = available_tables.sample
      created_time = Faker::Time.between(from: 30.days.ago, to: Time.current)
      
      # Randomly decide if it's a walk-in or a reservation order (70% walk-in)
      is_walk_in = [true, false, false, true, true, true, true].sample
      
      reservation = nil
      unless is_walk_in
        reservation = table.reservations.create!(
          customer_name: Faker::Name.name,
          phone: myanmar_phone,
          guest_count: rand(1..table.capacity),
          reserved_at: [created_time, Time.current + rand(1..24).hours].max,
          status: Reservation.statuses.keys.sample
        )
      end

      if created_time < 2.hours.ago
        status = ['completed', 'completed', 'completed', 'cancelled'].sample
      else
        status = ['pending', 'confirmed', 'preparing', 'ready'].sample
      end

      # Create Order
      order = table.orders.create!(
        reservation: reservation,
        status: status,
        payment_status: status == 'completed' ? 'paid' : 'unpaid',
        total_amount: 0, # Calculate below
        created_at: created_time
      )

      num_items = rand(1..5)
      selected_menus = available_menus.sample(num_items)
      
      selected_menus.each do |menu|
        quantity = rand(1..3)
        order.order_items.create!(
          menu: menu,
          quantity: quantity,
          unit_price: menu.price,
          subtotal: (quantity * menu.price).round(2)
        )
      end

      # Recalculate total based on items
      final_total = order.order_items.sum(:subtotal)
      order.update_column(:total_amount, final_total)

      # ==========================================
      # 6. PAYMENTS (Only for completed/paid orders)
      # ==========================================
      if order.paid?
        order.create_payment!(
          method: ['Cash', 'Card', 'QR'].sample,
          amount: final_total,
          status: :successful,
          transaction_id: fake_txn_id,
          created_at: created_time + 15.minutes
        )

        order.create_receipt!(
          pdf_url: "/tmp/receipts/order_#{order.id}_#{Time.current.to_i}.pdf",
          generated_at: created_time + 16.minutes
        )
      end
    end
  end
end