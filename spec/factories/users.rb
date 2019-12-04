FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.net"
  end

  factory :user do |f|
    email
    password {'123456'}
    password_confirmation {'123456'}
    before(:create, &:skip_confirmation!)
  end
end
