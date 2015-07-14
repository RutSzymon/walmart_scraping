class Product < ActiveRecord::Base
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :walmart_id, presence: true, uniqueness: true

  def to_s
    name
  end
end