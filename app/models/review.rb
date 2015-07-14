class Review < ActiveRecord::Base
  belongs_to :product

  validates :content, presence: true
  validates :product, presence: true
  validates :published_at, presence: true
  validates :stars, presence: true
  validates :walmart_id, presence: true
end