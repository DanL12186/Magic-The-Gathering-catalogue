require 'test_helper'

class CardTest < ActiveSupport::TestCase

  test "Card can't be saved without an edition, name, and multiverse_id" do
    #no edition
    card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 999)
    assert_not card.save

    #no multiverse_id
    card = Card.new(name: "Fritada", artist: "Michelangelo", colors: ["Blue"])
    assert_not card.save

    #no name
    assert_raises(NoMethodError) do
      card = Card.new(edition: "Sistine", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 999)
      card.save
    end
  end

  test "Card is saved with an edition and a name" do
    card = Card.new(name: "Fritada", edition: "Starch", artist: "Michelangelo", colors: ["Blue"], multiverse_id: 999)
    
    assert card.save
  end
  
  test "Card can access all users who 'own' it" do
    card = Card.new(name: "Potato", edition: "Snacks", colors: ["White"], multiverse_id: 111)
    card.save
    
    user1 = User.new(name: "Joe", email: "celtic@ts.net", password: "butwhatifwe")
    user1.save

    user2 = User.new(name: "Barack", email: "renegade@dj.org", password: "no,joe..")
    user2.save

    UsersCard.create(card_id: card.id, user_id: user1.id)
    UsersCard.create(card_id: card.id, user_id: user2.id)

    assert card.users.map(&:name) == ["Joe", "Barack"]
  end

  test "Card can access all decks it belongs to when supplied with necessary information" do
    card = Card.new(name: "Potato", edition: "Snacks", colors: ["White"], multiverse_id: 112)
    user = User.new(name: "Barack", email: "renegade@dj.org", password: 'no,joe..')

    [card, user].each(&:save)

    deck1 = Deck.create(name: "Paper", user_id: user.id)
    deck2 = Deck.create(name: "Tiger", user_id: user.id)
    
    DecksCard.create(card_id: card.id, deck_id: deck1.id)
    DecksCard.create(card_id: card.id, deck_id: deck2.id)
    
    assert Card.find(card.id).decks.map(&:name) == ["Paper", "Tiger"]
  end

end