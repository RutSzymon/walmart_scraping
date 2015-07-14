# encoding: utf-8
require "rails_helper"

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

  describe "via DB columns" do
    %w(name walmart_id created_at updated_at).each do |column_name|
      it { should have_db_column(column_name) }
    end
  end
end