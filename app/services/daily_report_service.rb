require "prawn"

class DailyReportService
  def initialize(restaurant, date)
    @restaurant = restaurant
    @date = date.to_date
  end

  def generate_pdf
    Prawn::Document.new do |pdf|
      pdf.text "#{@restaurant.name} Daily Sales Report", size: 18, style: :bold, align: :center
      pdf.text @date.strftime("%B %d, %Y"), size: 10, align: :center
      pdf.move_down 20

      orders = completed_orders

      pdf.text "Completed Orders: #{orders.count}", size: 12
      pdf.text "Total Sales: #{currency(total_sales)}", size: 12
      pdf.move_down 15

      pdf.text "Orders", size: 14, style: :bold
      pdf.move_down 5

      if orders.any?
        orders.each do |order|
          pdf.text "Order ##{order.id} - #{currency(order.total_amount)}", size: 10
        end
      else
        pdf.text "No completed orders for this date.", size: 10, style: :italic
      end
    end
  end

  private

  def completed_orders
    @completed_orders ||= @restaurant.orders.completed.where(created_at: @date.all_day)
  end

  def total_sales
    completed_orders.sum(:total_amount)
  end

  def currency(value)
    format("₱%.2f", value.to_f)
  end
end
