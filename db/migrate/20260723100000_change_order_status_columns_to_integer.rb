class ChangeOrderStatusColumnsToInteger < ActiveRecord::Migration[7.0]
  def change
    change_column :orders, :status, :integer, using: "status::integer"
    change_column :orders, :payment_status, :integer, using: "payment_status::integer"
  end
end
