require 'rails_helper'

RSpec.describe Team, type: :model do
  let(:subject) { FactoryBot.build(:team, balance: Money.new(100, 'IDR')) }

  include_examples 'Transaction Actor Examples'

  context 'associations' do
    it { is_expected.to belong_to(:owner).class_name('User').optional(true) }
    it { is_expected.to have_many(:memberships).dependent(:destroy) }
    it { is_expected.to have_many(:members).class_name('User').through(:memberships) }
  end

  context 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end
end
