require 'rails_helper'
require 'pry'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:card) { create(:card) }
  
  context "validations:" do
    describe "missing required attributes:" do
      it "can't be saved without a name" do
        user = User.create(password: 'my password')
        expect(user.errors.messages[:name]).to include("can't be blank")
      end

      it "can't be saved without a password" do
        user = User.create(name: "Guy")
        expect(user.errors.messages[:password]).to include("can't be blank")
      end

      it "password length must be >= 8" do
        user = User.create(name: "Guy", password: "shortPW")
        expect(user.errors.messages[:password]).to include("is too short (minimum is 8 characters)")
      end
    end

    it "name must be unique" do
      user_with_existing_name = user.dup
      user_with_existing_name.save
      expect(user_with_existing_name.errors.messages[:name]).to include("has already been taken")
    end

    it "can be saved without an email, but not with email must be unique" do
      user_without_email = User.create(name: "name", password: "password")
      expect(user_without_email.valid?).to be true

      user_with_existing_email = user.dup
      user_with_existing_email.save
      expect(user_with_existing_email.errors.messages[:email]).to include("has already been taken")
    end
  end
  
  context "assocations:" do
    it "can access all collections it owns" do
      10.times { create(:collection, user_id: user.id) }

      expect(user.collections.size).to eq(10)
    end

    it "can access all decks it owns" do
      10.times { create(:deck, user_id: user.id) }
      
      expect(user.decks.size).to eq(10)
    end

    it "can access all cards it owns through users_cards" do
      UsersCard.create(user_id: user.id, card_id: card.id)

      cards = user.cards

      expect(cards.first.class).to eq(Card)
      expect(cards.size).to eq(1)
    end
  end
end