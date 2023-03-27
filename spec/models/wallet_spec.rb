require 'rails_helper'

RSpec.describe Wallet, type: :model do
  let(:subject) { FactoryBot.build(:wallet) }

  it { is_expected.to monetize(:balance) }

  context 'associations' do
    it { is_expected.to belong_to(:owner) }
  end
end
