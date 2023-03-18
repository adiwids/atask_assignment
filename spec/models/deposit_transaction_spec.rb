require 'rails_helper'

RSpec.describe DepositTransaction, type: :model do
  let(:subject) { FactoryBot.build(:deposit_transaction, amount: amount) }
  let(:amount) { Money.new(100, 'IDR') }

  include_examples 'Transaction Examples'

  context 'with negative amount' do
    let(:amount) { Money.new(-1, 'IDR') }

    it { expect(subject).to be_invalid }
  end
end
