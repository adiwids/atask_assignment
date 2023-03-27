class Wallet < ApplicationRecord
  belongs_to :owner, polymorphic: true

  monetize :balance_cents, numericality: { greater_than_or_equal_to: 0 }

  def empty?
    balance.zero?
  end
end
