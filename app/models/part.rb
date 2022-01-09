class Part < ApplicationRecord
  validates :title, :detail_num, :o_e, presence: true
  validates :o_e, uniqueness: true
end
