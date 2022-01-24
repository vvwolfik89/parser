class Part < ApplicationRecord
  validates :detail_num, :o_e, presence: true
  validates :o_e, uniqueness: true
  has_many :data_ratings

  scope :without_current_data_ratings, -> (date_range) {
    includes(:data_ratings).where.not(id: DataRating.where(created_at: date_range).pluck(:part_id))
  }
end
