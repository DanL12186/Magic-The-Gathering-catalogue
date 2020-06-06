require 'rails_helper'
require 'pry'

RSpec.describe HomePageController, type: :controller do
  render_views

  describe "GET root_path" do
    Card.create(
      name: "Air Elemental", edition: "Alpha", artist: "Richard Thomas", card_type: "Creature", rarity: "Uncommon", 
      multiverse_id: 94, mana: ["3", "Blue", "Blue"], subtypes: ["Elemental"], color: "Blue", colors: ["Blue"], 
      img_url: "https://cdn1.mtggoldfish.com/images/gf/Air%2BElemental%2B%255BLEA%255D.jpg", iconic: true
    )

    it "renders the home page template" do
      get :home
      expect(response.body).to match /MTG Catalogue/
    end

    it "should include search bar in home page template" do
      get :home
      expect(@response.body).to match("Card Search")
    end

    it "should display iconic cards" do
      get :home
      expect(response.body).to have_css('.card_img')
    end

    it "doesn't show the home page link" do
      get :home
      expect(response.body).to_not match /Home/
    end
  end
end