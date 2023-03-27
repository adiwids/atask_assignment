module WalletOwner
  extend ActiveSupport::Concern

  included do
    has_one :wallet, as: :owner, dependent: :destroy
    has_many :transactions, as: :owner

    # partial nullify polymorphic association to keep owner type
    before_destroy :nullify_transactions_owner
    before_destroy :check_remaining_balance
  end

  def deposit(amount)
    transaction do
      begin
        DepositTransaction.create!(owner: self, amount: amount)
        current_balance = wallet.balance
        wallet.update!(balance: current_balance + amount)
      rescue ActiveRecord::RecordInvalid => error
        errors.add(:base, :deposit_failure, message: error.message)
        raise ActiveRecord::Rollback
      end
    end
  end

  def withdraw(amount)
    transaction do
      begin
        if check_balance(amount)
          WithdrawalTransaction.create!(owner: self, amount: amount)
          current_balance = wallet.balance
          wallet.update(balance: current_balance - amount)
        else
          raise ActiveRecord::RecordInvalid.new(self)
        end
      rescue ActiveRecord::RecordInvalid => error
        errors.add(:base, :withdraw_failure, message: error.message)
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def nullify_transactions_owner
    transactions.update_all(owner_id: nil)
  end

  def check_balance(amount)
    errors.add(:base, :insufficient_balance) and return false if wallet.balance < amount.abs
  end

  def check_remaining_balance
    errors.add(:base, :wallet_not_empty) and abort unless wallet.empty?
  end
end
