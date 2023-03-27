require 'rails_helper'

RSpec.describe WithdrawalTransaction, type: :model do
  let(:subject) { FactoryBot.build(:withdrawal_transaction, amount: amount) }
  let(:amount) { Money.new(-100, 'IDR') }

  include_examples 'Transaction Examples'

  context 'with positive amount' do
    let(:amount) { Money.new(100, 'IDR') }

    it { expect(subject).to be_invalid }
  end
end
