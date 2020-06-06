require 'rails_helper'
require 'pry'

RSpec.describe Card, type: :model do
  it "can't be saved without an edition, name, and multiverse_id" do
    #no edition
    card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 99)
    expect(card.save).to be_falsey

    #no multiverse_id
    card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"])
    expect(card.save).to be_falsey

    #no name
    begin
      card = Card.new(edition: "Sistine", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 9933)
      card.valid?
    rescue NoMethodError => error
      expect(error).to be_truthy
    end
  end

  it "is saved with an edition and a name" do
    card = Card.new(name: "Fritada", edition: "Starch", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 1999)

    expect(card.save).to be true
  end
  
  it "Card can access all users who 'own' it" do
    card = Card.new(name: "Potato", edition: "Snacks", colors: ["White"], multiverse_id: 111)
    card.save
    
    user1 = User.new(name: "Joe", email: "celtic@ts.net", password: "butwhatifwe")
    user1.save

    user2 = User.new(name: "Barack", email: "renegade@dj.org", password: "no,joe..")
    user2.save

    UsersCard.create(card_id: card.id, user_id: user1.id)
    UsersCard.create(card_id: card.id, user_id: user2.id)

    expect(card.users.map(&:name)).to eq ["Joe", "Barack"]
  end

  it "Card can access all decks it belongs to when supplied with necessary information" do
    card = Card.new(name: "Potato", edition: "Snacks", colors: ["White"], multiverse_id: 112)
    user = User.new(name: "Barack", email: "renegade@dj.org", password: 'no,joe..')

    [card, user].each(&:save)

    deck1 = Deck.create(name: "Paper", user_id: user.id)
    deck2 = Deck.create(name: "Tiger", user_id: user.id)
    
    DecksCard.create(card_id: card.id, deck_id: deck1.id)
    DecksCard.create(card_id: card.id, deck_id: deck2.id)
    
    expect(Card.find(card.id).decks.map(&:name)).to eq ["Paper", "Tiger"]
  end
end