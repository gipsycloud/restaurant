class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :table, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true
      t.string :status
      t.decimal :total_amount
      t.string :payment_status

      t.timestamps
    end
  end
end
