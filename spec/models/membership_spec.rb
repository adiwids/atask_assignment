require 'rails_helper'

RSpec.describe Membership, type: :model do
  let(:subject) { FactoryBot.build(:membership) }

  it 'has inactive status by default' do
    expect(subject).to be_inactive
  end

  context 'associations' do
    it { is_expected.to belong_to(:team).required(true).counter_cache('members_count').touch(true) }
    it { is_expected.to belong_to(:member).class_name('User').required(true) }
  end
end
