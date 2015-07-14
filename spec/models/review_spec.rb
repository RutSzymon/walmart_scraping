# encoding: utf-8
require "rails_helper"

RSpec.describe Review, type: :model do
  describe "via relations" do
    it { should belong_to(:product) }
  end

  describe "via validations" do
    before(:each) do
      @review = FactoryGirl.build(:review)
    end

    it { expect(@review).to be_valid }

    it { should validate_presence_of(:content) }

    it { should validate_presence_of(:product) }

    it { should validate_presence_of(:published_at) }

    it { should validate_presence_of(:stars) }
  end

  describe "via DB columns" do
    %w(title content stars published_at product_id created_at updated_at).each do |column_name|
      it { should have_db_column(column_name) }
    end
  end
end