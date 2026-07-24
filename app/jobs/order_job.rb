class OrderJob
  include Sidekiq::Job

  def perform(order_id)
    order = Order.include(:order_items, :table, :restaurant).find(order_id)

    order.update!(status: :confirmed, payment_status: :paid)
  end
end
