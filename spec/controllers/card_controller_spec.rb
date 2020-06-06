require 'rails_helper'
require 'pry'

RSpec.describe CardsController, type: :controller do
  render_views

  it "should get reserved list" do
    get :reserved_list

    expect(@response.body).to match "Reserved List"
  end
end