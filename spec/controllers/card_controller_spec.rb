require 'rails_helper'
require 'pry'

RSpec.describe CardsController, type: :controller do
  render_views

  it "should get reserved list" do
    get :reserved_list

    expect(@response.body).to match "Reserved List"
  end

  it "should get a card that exists" do
    card = create(:card)

    visit "/cards/#{card.edition}/#{card.name}"
    
    expect(page.status_code).to eq 200
    expect(page).to have_content("#{card.edition} #{card.name}")
  end

  it "should render 404 if card doesn't exist" do
    visit '/cards/Alpha/nocard'

    expect(page.status_code).to eq 404
  end
end