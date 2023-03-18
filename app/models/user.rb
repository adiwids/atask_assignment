class User < ApplicationRecord
  include TransactionActor

  has_many :memberships, foreign_key: 'member_id', dependent: :destroy
  has_many :teams, through: :memberships, source: :team
  has_many :owned_teams, class_name: 'Team', foreign_key: 'owner_id', dependent: :nullify

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
