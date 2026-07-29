require "fileutils"

class ReceiptJob
  include Sidekiq::Job
  sidekiq_options queue: :pdfs

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return if order.nil?

    pdf_document = ReceiptPdfService.new(order).generate

    receipts_dir = Rails.root.join("public/receipts")
    FileUtils.mkdir_p(receipts_dir)

    filename = "receipt_order_#{order.id}_#{Time.current.to_i}.pdf"
    filepath = receipts_dir.join(filename)

    File.open(filepath, "wb") do |file|
      file.write(pdf_document.render)
    end

    order.create_receipt!(
      pdf_url: "/receipts/#{filename}",
      generated_at: Time.current
    )

    Rails.logger.info "Receipt generated successfully for Order ##{order.id}"
  end
end
