FactoryBot.define do
  factory :transaction do
    user_transaction
    date_time { Time.zone.now }
    amount_cents { 100 }
    amount_currency { 'IDR' }

    trait :withdrawal do
      transaction_type { 'WithdrawalTransaction' }
    end

    trait :deposit do
      transaction_type { 'DepositTransaction' }
    end

    trait :user_transaction do
      association :owner, factory: :user
    end
  end

  factory :withdrawal_transaction, parent: :transaction, traits: %i[withdrawal]
  factory :deposit_transaction, parent: :transaction, traits: %i[deposit]
end
