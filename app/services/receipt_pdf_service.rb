class ReceiptPdfService
  def initialize(order)
    @order = order
  end

  def generate
    ReceiptPdf.new(@order)
  end
end
