require 'prawn/measurement_extensions'

class ReceiptPdf < Prawn::Document
  def initialize(order)
    super(page_size: [80.mm, 200.mm], margin: 5.mm)
    @order = order
    @restaurant = order.table.restaurant
    generate
  end

  private

  def generate
    header
    order_details
    items_table
    totals
    footer
  end

  def header
    text @restaurant.name, size: 14, align: :center, style: :bold
    text @restaurant.address, size: 8, align: :center
    text @restaurant.phone, size: 8, align: :center
    move_down 5
    draw_line
  end

  def order_details
    text "Order ##{@order.id}", size: 9, style: :bold
    text "Table: #{@order.table.table_number}", size: 8
    text "Time: #{@order.created_at.strftime('%Y-%m-%d %H:%M')}", size: 8
    move_down 3
    draw_line
  end

  def items_table
    @order.order_items.each do |item|
      row = "#{item.menu.name.ljust(15)} x#{item.quantity}"
      text row, size: 8
      text "$#{item.subtotal.round(2)}", size: 8, align: :right
      move_down 1
    end
    draw_line
  end

  def totals
    text "TOTAL", size: 10, style: :bold
    text "$#{@order.total_amount.round(2)}", size: 12, align: :right, style: :bold
    move_down 3
    draw_line
  end

  def footer
    move_down 5
    text "Thank you for dining with us!", size: 8, align: :center
    text "Please come again", size: 7, align: :center
  end

  def draw_line
    stroke_horizontal_line bounds.left, bounds.right
    move_down 3
  end
end