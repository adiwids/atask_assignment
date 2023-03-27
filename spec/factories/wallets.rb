FactoryBot.define do
  factory :wallet do
    association :owner, factory: :user
    balance_cents { 100 }
    balance_currency { 'IDR' }
  end
end
