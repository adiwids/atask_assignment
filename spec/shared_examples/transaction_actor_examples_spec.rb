require 'rails_helper'

RSpec.shared_examples 'Transaction Actor Examples' do
  it { is_expected.to monetize(:balance) }

  context 'associations' do
    it { is_expected.to have_many(:transactions) }
  end

  context 'on destroy' do
    it 'nullifies transaction owner ID' do
      expect_any_instance_of(described_class).to receive_message_chain(:transactions, :update_all).with(owner_id: nil)
      subject.destroy
    end
  end

  describe '#deposit' do
    context 'with valid amount' do
      let(:amount) { Money.new(100, 'IDR')}

      it 'creates deposit transaction' do
        expect(DepositTransaction.where(owner: subject).count).to be_zero
        subject.deposit(amount)
        expect(DepositTransaction.where(owner: subject).count).to be_positive
      end

      it 'adds balance' do
        current_balance = subject.balance
        expect { subject.deposit(amount) }.to change { subject.balance }.from(current_balance).to(current_balance + amount)
      end
    end

    context 'with negative amount' do
      let(:amount) { Money.new(-1, 'IDR')}

      it 'does not create deposit transaction' do
        expect { subject.deposit(amount) }.not_to change { DepositTransaction.where(owner: subject).count }.from(0)
      end

      it 'results deposit error' do
        subject.deposit(amount)
        expect(subject.errors.map(&:attribute)).to include(:base)
        expect(subject.errors.full_messages.first).to match(/amount is invalid/i)
      end

      it 'keeps balance' do
        expect { subject.deposit(amount) }.not_to change { subject.balance }
      end
    end
  end

  describe '#withdraw' do
    context 'with valid amount' do
      let(:amount) { subject.balance }

      context 'and balance sufficient' do
        it 'creates withdraw transaction' do
          expect(WithdrawalTransaction.where(owner: subject).count).to be_zero
          subject.withdraw(amount)
          expect(WithdrawalTransaction.where(owner: subject).count).to be_positive
        end

        it 'reduces balance' do
          current_balance = subject.balance
          expect { subject.withdraw(amount) }.to change { subject.balance }.from(current_balance).to(current_balance - amount)
        end
      end

      context 'and balance insufficient' do
        it 'does not create withdrawal transaction' do
          expect { subject.withdraw(amount) }.not_to change { WithdrawalTransaction.where(owner: subject).count }.from(0)
        end

        it 'results withdrawal error' do
          subject.withdraw(amount)
          expect(subject.errors.map(&:attribute)).to include(:base)
          expect(subject.errors.full_messages.first).to match(/balance is insufficient/i)
        end

        it 'keeps balance' do
          expect { subject.withdraw(amount) }.not_to change { subject.balance }
        end
      end
    end

    context 'with negative amount' do
      let(:amount) { Money.new(-1, 'IDR')}

      it 'does not create withdrawal transaction' do
        expect { subject.withdraw(amount) }.not_to change { WithdrawalTransaction.where(owner: subject).count }.from(0)
      end

      it 'results withdrawal error' do
        subject.withdraw(amount)
        expect(subject.errors.map(&:attribute)).to include(:base)
        expect(subject.errors.full_messages.first).to match(/amount is invalid/i)
      end

      it 'keeps balance' do
        expect { subject.withdraw(amount) }.not_to change { subject.balance }
      end
    end
  end
end