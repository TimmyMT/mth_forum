FactoryBot.define do
  factory :post do
    title { "MyString" }
    body { "MyText" }

    trait :invalid_post do
      title { nil }
      body { nil }
    end
  end
end
