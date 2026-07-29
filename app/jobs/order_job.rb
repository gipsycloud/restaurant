class OrderJob
  include Sidekiq::Job

  def perform(order_id)
    order = Order.includes(:order_items, :table).find_by(id: order_id)
    return if order.nil?

    order.update!(status: :confirmed, payment_status: :paid)
  end
end
