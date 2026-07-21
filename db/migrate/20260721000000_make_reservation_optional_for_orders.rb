class MakeReservationOptionalForOrders < ActiveRecord::Migration[7.0]
  def change
    change_column_null :orders, :reservation_id, true
  end
end
