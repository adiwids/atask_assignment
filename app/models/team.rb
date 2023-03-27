class Team < ApplicationRecord
  include WalletOwner

  belongs_to :owner, class_name: 'User', optional: true
  has_many :memberships, dependent: :destroy
  has_many :members, class_name: 'User', through: :memberships, source: :member

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
