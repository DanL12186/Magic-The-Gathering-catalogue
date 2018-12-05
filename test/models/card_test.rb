require 'test_helper'

class CardTest < ActiveSupport::TestCase

  test "Card can't be saved without an edition and a name" do
    card = Card.new(name: "Fritada", artist: "Michelangelo")
    assert_not card.save

    assert_raises(NoMethodError) do
      card = Card.new(edition: "Sistine", artist: "Michelangelo")
      card.save
    end
  end

  test "Card is saved with an edition and a name" do
    card = Card.new(name: "Fritada", edition: "Starch", artist: "Michelangelo")
    
    assert card.save
  end
  
  test "Card can access all users who 'own' it" do
    card = Card.new(name: "Potato", edition: "Snacks")
    card.save
    
    user1 = User.new(name: "Joe", email: "celtic@ts.net", password: 'butwhatifwe')
    user1.save

    user2 = User.new(name: "Barack", email: "renegade@dj.org", password: 'no,joe')
    user2.save

    UsersCard.create(card_id: card.id, user_id: user1.id)
    UsersCard.create(card_id: card.id, user_id: user2.id)
    
    assert Card.find(card.id).users.map(&:name) == ["Joe", "Barack"]
  end

  test "Card can access all decks it belongs to when supplied with necessary information" do
    card = Card.new(name: "Potato", edition: "Snacks")
    card.save
    
    user = User.new(name: "Barack", email: "renegade@dj.org", password: 'no,joe')
    user.save

    deck1 = Deck.new(name: "Paper", user_id: user.id)
    deck1.save
    
    deck2 = Deck.new(name: "Tiger", user_id: user.id)
    deck2.save

    DecksCard.create(card_id: card.id, deck_id: deck1.id)
    DecksCard.create(card_id: card.id, deck_id: deck2.id)
    
    assert Card.find(card.id).decks.map(&:name) == ["Paper", "Tiger"]
  end

end