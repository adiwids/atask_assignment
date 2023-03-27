FactoryBot.define do
  factory :team do
    association :owner, factory: :user
    sequence(:name) { |n| "Team #{n}" }
    members_count { 0 }

    transient do
      initial_balance { Money.new(0, 'IDR') }
    end

    after(:build) do |factory, evaluator|
      factory.build_wallet(balance: evaluator.initial_balance)
    end

    after(:create) do |factory, evaluator|
      factory.create_wallet(balance: evaluator.initial_balance)
    end
  end

  factory :team_with_initial_balance, parent: :team do
    initial_balance { Money.new(10000, 'IDR') }

    after(:create) do |factory, evaluator|
      FactoryBot.create(:transaction, :deposit, owner: factory, owner_name: factory.name, amount: evaluator.initial_balance)
    end
  end
end
