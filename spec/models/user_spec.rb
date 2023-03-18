require 'rails_helper'

RSpec.describe User, type: :model do
  let(:subject) { FactoryBot.build(:user) }

  include_examples 'Transaction Actor Examples'

  context 'associations' do
    it { is_expected.to have_many(:memberships).with_foreign_key('member_id').dependent(:destroy) }
    it { is_expected.to have_many(:teams).through(:memberships) }
    it { is_expected.to have_many(:owned_teams).class_name('Team').with_foreign_key('owner_id').dependent(:nullify) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  end

  context 'on destroy' do
    let(:subject) { FactoryBot.create(:user_with_initial_balance) }

    context 'membership' do
      let(:subject) { FactoryBot.create(:team_member) }

      it 'removes membership related to user' do
        expect(subject.memberships).to be_any
        subject.destroy
        expect(subject.memberships).to be_empty
      end
    end

    context 'owned team' do
      let(:subject) { FactoryBot.create(:team_member, team_owner: true) }

      it 'removes ownership of owned teams related to user' do
        expect(subject.owned_teams).to be_any
        subject.destroy
        expect(subject.owned_teams).to be_empty
      end
    end
  end
end
