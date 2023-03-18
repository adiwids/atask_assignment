FactoryBot.define do
  factory :team do
    association :owner, factory: :user
    sequence(:name) { |n| "Team #{n}" }
    members_count { 0 }
    balance_cents { 100 }
    balance_currency { 'IDR' }
  end
end
