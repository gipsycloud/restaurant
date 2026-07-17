class CreateReceipts < ActiveRecord::Migration[7.0]
  def change
    create_table :receipts do |t|
      t.references :order, null: false, foreign_key: true
      t.string :pdf_url
      t.datetime :generated_at

      t.timestamps
    end
  end
end
