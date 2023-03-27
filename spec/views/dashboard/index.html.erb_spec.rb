require 'rails_helper'

RSpec.describe "dashboard/index.html.erb", type: :view do
  before do
    render
  end

  it 'renders view' do
    assert_select "h1", "Dashboard#index"
  end
end
