module StatusHelper
	def order_status_badge(status)
    case status
    when 'pending' then 'bg-warning text-dark'
    when 'preparing' then 'bg-info'
    when 'ready' then 'bg-success'
    when 'completed' then 'bg-secondary'
    when 'cancelled' then 'bg-danger'
    else 'bg-light text-dark'
    end
  end

  def payment_status_badge(status)
    case status
    when 'paid' then 'bg-success'
    when 'unpaid' then 'bg-warning text-dark'
    when 'refunded' then 'bg-info'
    else 'bg-light text-dark'
    end
  end
end
