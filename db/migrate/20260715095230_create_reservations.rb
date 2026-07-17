class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.references :table, null: false, foreign_key: true
      t.string :customer_name
      t.string :phone
      t.integer :guest_count
      t.datetime :reserved_at
      t.string :status

      t.timestamps
    end
  end
end
