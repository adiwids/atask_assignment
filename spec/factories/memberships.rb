FactoryBot.define do
  factory :membership do
    association :team
    association :member, factory: :user
    inactive

    trait :inactive do
      status { 'inactive' }
    end

    trait :active do
      status { 'active' }
    end
  end
end
