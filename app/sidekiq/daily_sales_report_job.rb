class DailySalesReportJob
  include Sidekiq::Job
  queue_as :reports

  def perform
    Restaurant.find_each do |restaurant|
      today_order = restaurant.orders.completed
      .where(created_at: Date.today.all_day)

      total_sales = today_orders.sum(total_amount)
      order_count = today_orders.count

      Rails.logger.info "#{restaurant.name} Daily Report: " \
                        "#{order_count} orders, $#{total_sales}"

      GenerateSalesReportJob.perform_later(restaurant.id, Date.today)                  
    end
  end
end
