class Transaction < ApplicationRecord
  self.table_name = 'transactions'
  self.inheritance_column = 'transaction_type'

  monetize :amount_cents
  validate :check_amount

  belongs_to :owner, polymorphic: true

  before_validation :set_amount_sign

  private

  def check_amount
    if transaction_type == 'DepositTransaction'
      errors.add(:amount_cents, :invalid) if amount_cents < 0
    elsif transaction_type == 'WithdrawalTransaction'
      errors.add(:amount_cents, :invalid) if amount_cents > 0
    end
  end

  def set_amount_sign
    self.amount_cents = amount_cents * signer_value
  end

  def signer_value
    transaction_type == 'WithdrawalTransaction' ? -1 : 1
  end
end
