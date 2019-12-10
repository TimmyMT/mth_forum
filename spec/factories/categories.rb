FactoryBot.define do
  factory :category do
    name { "MyCategory" }

    trait :invalid_category do
      name { nil }
    end
  end
end
