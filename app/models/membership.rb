class Membership < ApplicationRecord
  enum status: %i[inactive active].freeze

  belongs_to :team, counter_cache: 'members_count', touch: true
  belongs_to :member, class_name: 'User'

  validates :member_id, uniqueness: { scope: :team_id }

  after_destroy_commit :remove_ownership

  private

  def remove_ownership
    team.update(owner_id: nil) if team.owner_id == member_id
  end
end
