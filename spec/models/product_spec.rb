# encoding: utf-8
require "rails_helper"
require "nokogiri"
require "open-uri"

RSpec.describe Product, type: :model do
  describe "via relations" do
    it { should have_many(:reviews) }
  end

  describe "via validations" do
    before(:each) do
      @product = FactoryGirl.build(:product)
    end

    it { expect(@product).to be_valid }

    it { should validate_presence_of(:name) }

    it { should validate_presence_of(:walmart_id) }

    it { should validate_uniqueness_of(:walmart_id) }
  end

  describe "via class methods" do
    context "add_or_update" do
      context "unique url" do
        it "should create new instance" do
          product = Product.add_or_update("http://www.walmart.com/ip/44990290")
          expect(product).to be_persisted
          expect(product.name).to include("Toshiba Black")
          expect(product.walmart_id).to eq(44990290)
        end

        it "should create reviews" do
          product = Product.add_or_update("http://www.walmart.com/ip/44990290")
          expect(product.reviews.count).to be >= 4
          first_review = product.reviews.order(:id).first
          expect(first_review.title).to eq("Good everyday computer")
          expect(first_review.content).to include("This is a good computer for everyday tasks")
          expect(first_review.stars).to eq(4)
          expect(first_review.published_at).to eq(Date.parse("10-06-2015"))
        end
      end
    end
  end

  describe "via DB columns" do
    %w(name walmart_id created_at updated_at).each do |column_name|
      it { should have_db_column(column_name) }
    end
  end
end