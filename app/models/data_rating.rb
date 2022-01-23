class DataRating < ApplicationRecord
  validates :currency, :data, presence: true
  validate :check_date_uniq

  protected

  def check_date_uniq
    date_time = DateTime.now
    date_range = (date_time.beginning_of_day .. date_time.end_of_day)
    unless DataRating.where(created_at: date_range).where(part_id: self.part_id).empty?
      errors.add(:base, "This is part already have rating for current day")
    end
  end

end
