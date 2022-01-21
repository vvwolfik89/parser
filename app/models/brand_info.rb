class BrandInfo < ApplicationRecord
  validates :brand_name, presence: true, uniqueness: true
end
