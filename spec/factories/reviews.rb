FactoryGirl.define do
  factory :review do
    sequence(:title){ |n| "Tytuł #{n}" }
    sequence(:content){ |n| "Treść #{n}" }
    stars{ rand(1..5) }
    published_at Time.now
    product factory: :product, strategy: :build_stubbed
    sequence(:walmart_id){ |n| "#{n}" }
  end
end