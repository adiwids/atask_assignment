require 'rails_helper'

RSpec.shared_examples 'Transaction Examples' do
  it { is_expected.to monetize(:amount) }

  context 'associations' do
    it { is_expected.to belong_to(:owner) }
  end
end