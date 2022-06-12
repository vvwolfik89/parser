class SparesController < ApplicationController
  def index
    date_time = DateTime.current
    date_range = (date_time.beginning_of_day .. date_time.end_of_day)
    part_ids = Part.without_current_data_ratings(date_range).uniq.pluck(:id)
    part_ids.each do |part_id|
      ParsingJob.perform_async(part_id)
    end
  end
end
