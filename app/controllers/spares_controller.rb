class SparesController < ApplicationController
  def index
    date_time = DateTime.current
    date_range = (date_time.beginning_of_day .. date_time)
    parser_data = ParserService.new(parts: Part.without_current_data_ratings(date_range).last(50).uniq)

    @data = parser_data.show_data
  end
end
