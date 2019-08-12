require 'rails_helper'
require 'pry'

RSpec.describe HomePageController, type: :controller do
  render_views

  describe "GET root_path" do            
    # it "assigns @teams" do
    #   get :root_path
    #   expect(assigns(:teams)).to eq([team])
    # end

    it "renders the home page template and doesn't show the home page link" do
      get :home

      expect(response.body).to match /MTG Catalogue/
      expect(response.body).to_not match /Home/      
    end
  end
end