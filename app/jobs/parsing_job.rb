class ParsingJob
  include Sidekiq::Job

  def perform
    date_time = DateTime.current
    date_range = (date_time.beginning_of_day .. date_time.end_of_day)
    parts = Part.without_current_data_ratings(date_range).uniq
    parts.each do |part|
      parser_data = ParserService.new(part)
      parser_data.show_data
    end
  end
end
