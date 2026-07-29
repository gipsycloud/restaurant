require "test_helper"

class ReceiptPdfServiceTest < ActiveSupport::TestCase
  def test_generate_returns_a_receipt_pdf_document
    restaurant = Struct.new(:name, :address, :phone).new(
      "The Garden Kitchen",
      "123 Main Street, Yangon City",
      "+95 917 123 4567"
    )
    table = Struct.new(:restaurant, :table_number).new(restaurant, 12)
    order = Struct.new(:id, :table, :order_items, :created_at, :total_amount).new(
      154,
      table,
      [],
      Time.current,
      102.6
    )

    pdf = ReceiptPdfService.new(order).generate

    assert_instance_of ReceiptPdf, pdf
  end
end
