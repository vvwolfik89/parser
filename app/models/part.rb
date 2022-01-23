class Part < ApplicationRecord
  validates :detail_num, :o_e, presence: true
  validates :o_e, uniqueness: true
  has_many :data_ratings

  scope :without_current_data_ratings, -> (date_range) {
    includes(:data_ratings).where.not(data_ratings: {created_at: date_range}).or(Part.where(data_ratings: {part_id: nil})).last(30)
  }
end
