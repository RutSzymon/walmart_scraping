FactoryGirl.define do
  factory :product do
    sequence(:name){ |n| "Nazwa #{n}" }
    sequence(:walmart_id){ |n| "#{n}" }
  end
end