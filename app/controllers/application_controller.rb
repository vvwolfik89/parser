class ApplicationController < ActionController::Base
  def current_date_range
    date_time = DateTime.current
    (date_time.beginning_of_day .. date_time.end_of_day)
  end
end
