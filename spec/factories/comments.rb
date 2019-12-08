FactoryBot.define do
  factory :comment do
    body { "MyComment" }

    trait :invalid_comment do
      body { nil }
    end
  end
end
