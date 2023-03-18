class Membership < ApplicationRecord
  enum status: %i[inactive active].freeze

  belongs_to :team, counter_cache: 'members_count', touch: true
  belongs_to :member, class_name: 'User'
end
