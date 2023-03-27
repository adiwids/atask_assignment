FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test.user#{n}@lvh.me" }

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

  factory :user_with_initial_balance, parent: :user do
    initial_balance { Money.new(10000, 'IDR') }

    after(:create) do |factory, evaluator|
      FactoryBot.create(:transaction, :deposit, owner: factory, owner_name: factory.email, amount: evaluator.initial_balance)
    end
  end

  factory :team_member, parent: :user do
    transient do
      team_owner { false }
    end

    after(:create) do |factory, evaluator|
      membership = FactoryBot.create(:membership, :active, member: factory)
      membership.team.update_column(:owner_id, factory.id) if evaluator.team_owner
    end
  end
end
