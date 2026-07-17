# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# Create Restaurant
restaurant = Restaurant.create!(
  name: "Myanmar Delight",
  address: "123 Food Street, Yangon",
  phone: "+959123456789"
)

# Create Admin User
restaurant.users.create!(
  name: "Admin User",
  email: "admin@gmail.com",
  role: "admin"
)

# Create Tables
(1..10).each do |n|
  restaurant.tables.create!(
    table_number: n,
    capacity: n <= 5 ? 4 : 8,
    status: :available
  )
end

# Menu Categories and Items
categories = {
  "Appetizer" => [
    { name: "Spring Rolls", price: 4.50 },
    { name: "Soup of the Day", price: 3.00 },
    { name: "Garlic Bread", price: 2.50 }
  ],
  "Main Course" => [
    { name: "Grilled Chicken", price: 12.00 },
    { name: "Pasta Carbonara", price: 10.50 },
    { name: "Fish & Chips", price: 11.00 },
    { name: "Steak Ribeye", price: 18.00 }
  ],
  "Beverage" => [
    { name: "Fresh Juice", price: 3.00 },
    { name: "Coffee", price: 2.50 },
    { name: "Beer", price: 4.00 }
  ],
  "Dessert" => [
    { name: "Chocolate Cake", price: 5.00 },
    { name: "Ice Cream", price: 3.50 }
  ]
}

categories.each do |category, items|
  items.each do |item|
    restaurant.menus.create!(
      name: item[:name],
      category: category,
      price: item[:price],
      is_available: true
    )
  end
end

puts "✅ Seed data created successfully!"
puts "   Restaurant: #{restaurant.name}"
puts "   Tables: #{restaurant.tables.count}"
puts "   Menu Items: #{restaurant.menus.count}"