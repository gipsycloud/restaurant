class DailySalesReportJob
  include Sidekiq::Job
  sidekiq_options queue: :reports

  def perform
    Restaurant.find_each do |restaurant|
      today_orders = restaurant.orders.completed.where(created_at: Date.current.all_day)

      total_sales = today_orders.sum(:total_amount)
      order_count = today_orders.count

      Rails.logger.info "#{restaurant.name} Daily Report: " \
                        "#{order_count} orders, $#{total_sales}"

      DailyReportJob.perform_async(restaurant.id, Date.current)
    end
  end
end
