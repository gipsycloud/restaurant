require "fileutils"

class DailyReportJob
  include Sidekiq::Job
  sidekiq_options queue: :pdfs

  def perform(restaurant_id, date = Date.current)
    restaurant = Restaurant.find_by(id: restaurant_id)
    return if restaurant.nil?

    report = DailyReportService.new(restaurant, date)
    pdf = report.generate_pdf

    report_dir = Rails.root.join("tmp/reports")
    FileUtils.mkdir_p(report_dir)

    report_path = report_dir.join("daily_report_#{restaurant.name.parameterize}_#{date}.pdf")
    pdf.render_file(report_path)
  end
end
