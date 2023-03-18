FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "test.user#{n}@lvh.me" }
    balance_cents { 100 }
    balance_currency { "IDR" }
  end

  factory :user_with_initial_balance, parent: :user do
    after(:create) do |factory, evaluator|
      FactoryBot.create(:transaction, :deposit, owner: factory, owner_name: factory.email, amount_cents: 100)
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
