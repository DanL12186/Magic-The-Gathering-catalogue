require 'rails_helper'
require 'pry'

RSpec.describe Card, type: :model do
  let(:user) { create(:user) }
  let(:card) { create(:card) }
  
  describe "missing required attributes:" do
    it "can't be saved without an edition" do
      card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 99)
      expect(card.save).to be false
    end

    it "can't be saved without a multiverse_id" do
      card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"])
      expect(card.save).to be false
    end

    it "can't be saved unless multiverse_id is unique" do
      duplicate = create(:card)
      duplicate.multiverse_id = card.multiverse_id
      duplicate.save
      
      expect(duplicate.errors.messages[:multiverse_id]).to include("has already been taken")
    end

    it "can't be saved without an edition" do
      card = Card.new(name: "Sistine", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 9933)

      expect(card.save).to be false
    end
  end

  it "is saved with a name, edition and multiverse_id" do
    expect(card.name).to be_truthy
    expect(card.edition).to be_truthy
    expect(card.multiverse_id).to be_truthy
    expect(card.valid?).to be true
  end
  
  context "assocations:" do
    it "can access all users who 'own' it" do
      user_one = create(:user)
      user_two = create(:user)

      UsersCard.create(card_id: card.id, user_id: user_one.id)
      UsersCard.create(card_id: card.id, user_id: user_two.id)

      expect(card.users.size).to eq(2)
    end

    it "can access all collections it belongs to" do
      collection_one = create(:collection)
      collection_two = create(:collection)

      CollectionsCard.create(card_id: card.id, collection_id: collection_one.id)
      CollectionsCard.create(card_id: card.id, collection_id: collection_two.id)

      expect(card.collections.size).to eq(2)
    end

    it "can access all decks it belongs to" do
      deck_one = create(:deck)
      deck_two = create(:deck)
      
      DecksCard.create(card_id: card.id, deck_id: deck_one.id)
      DecksCard.create(card_id: card.id, deck_id: deck_two.id)
      
      expect(Card.find(card.id).decks.size).to eq(2)
    end
  end
end