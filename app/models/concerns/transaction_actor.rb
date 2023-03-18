module TransactionActor
  extend ActiveSupport::Concern

  included do
    monetize :balance_cents

    has_many :transactions, as: :owner

    # partial nullify polymorphic association to keep owner type
    before_destroy :nullify_transactions_owner
  end

  def deposit(amount)
    transaction do
      begin
        DepositTransaction.create!(owner: self, amount: amount)
        update!(balance: balance + amount)
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
          update(balance: balance - amount)
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
    errors.add(:balance, :insufficient) and return false if balance < amount.abs
  end
end