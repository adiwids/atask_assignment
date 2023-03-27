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

  context 'validations' do
    it { is_expected.to validate_uniqueness_of(:member_id).scoped_to(:team_id) }
  end

  context 'on destroy' do
    context 'when removed member is team owner' do
      let(:membership) { FactoryBot.create(:membership) }

      before do
        @team = membership.team
        @team.update(owner_id: membership.member_id)
      end

      it 'removes ownership' do
        expect { membership.destroy }.to change { @team.owner_id }.from(membership.member_id).to(nil)
      end
    end
  end
end
