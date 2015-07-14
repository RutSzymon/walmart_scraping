require "nokogiri"
require "open-uri"

class Product < ActiveRecord::Base
  has_many :reviews, dependent: :destroy

  validates :name, presence: true
  validates :walmart_id, presence: true, uniqueness: true

  def self.add_or_update(url)
    doc = Nokogiri::HTML(open(url))
    reviews_url = doc.at_css("#WMItemSeeAllRevLnk")[:href]
    walmart_id = reviews_url.split("/")[3]
    (product = where(walmart_id: walmart_id).first) ? update_old(doc, product, reviews_url) : add_new(doc, walmart_id, name, reviews_url)
  end

  def to_s
    name
  end

  attr_accessor :url

  class << self
    private
    def add_new(doc, walmart_id, name, reviews_url)
      reviews_count = doc.at_css(".review-stats span").text.split(" ")[2].to_i
      name = doc.at_css(".product-name").text
      product = create(name: name, walmart_id: walmart_id)
      (1..reviews_count/20+1).each{ |page| add_reviews(product, reviews_url, page) }
      product
    end

    def update_old(doc, product, reviews_url)
      reviews_count = doc.at_css(".review-stats span").text.split(" ")[2].to_i
      new_reviews_count = reviews_count - product.reviews.size
      (product.reviews.size/20+1..reviews_count/20+1).each_with_index do |page, i|
        add_reviews(product, reviews_url, page, i == 0 ? new_reviews_count%20 : 0) if new_reviews_count != 0
      end
      product.touch
      product
    end

    def add_reviews(product, reviews_url, page, index = 0)
      url = "https://www.walmart.com#{reviews_url}?limit=20&page=#{page}&sort=submission-asc"
      doc = Nokogiri::HTML(open(url))
      doc.css(".js-customer-review")[-index..19].each do |doc_review|
        title = doc_review.at_css(".customer-review-title").text
        content = doc_review.at_css(".js-customer-review-text").text.gsub("Read more", "")
        stars = doc_review.css(".star-rated").length
        published_at = Date.strptime(doc_review.at_css(".customer-review-date").text, "%m/%d/%Y")
        product.reviews.create(title: title, content: content, stars: stars, published_at: published_at, walmart_id: doc_review["data-content-id"])
      end
    end
  end
end