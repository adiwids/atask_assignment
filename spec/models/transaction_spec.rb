require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:subject) { FactoryBot.build(:transaction) }

  include_examples 'Transaction Examples'
end
