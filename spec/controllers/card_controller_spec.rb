require 'rails_helper'
require 'pry'

RSpec.describe CardsController, type: :controller do
  render_views

  it "should get reserved list" do
    get :reserved_list

    expect(@response.body).to match "Reserved List"
  end

  it "should get a card that exists" do
    Card.create(
      name: "Forcefield", edition: "Alpha", artist: "Dan Frazier", card_type: "Artifact", rarity: "Rare", 
      multiverse_id: 12, mana: ["3"], subtypes: [], color: "Colorless", colors: [], 
      img_url: '', cropped_img: ''
    )

    visit '/cards/Alpha/Forcefield'

    expect(page.status_code).to eq 200
    expect(page).to have_content("Alpha Forcefield")
  end

  it "should render 404 if card doesn't exist" do
    visit '/cards/Alpha/nocard'

    expect(page.status_code).to eq 404
  end
end