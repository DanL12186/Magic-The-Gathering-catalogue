require 'cgi'

class Card < ApplicationRecord
  include CardSets

  has_many :users_cards
  has_many :decks_cards, dependent: :destroy
  has_many :collections_cards

  has_many :users, through: :users_cards
  has_many :decks, through: :decks_cards

  validates :multiverse_id, uniqueness: true
  validates :name, :edition, presence: true

  BASE_URL = "https://cdn1.mtggoldfish.com/images/gf".freeze

  def initialize(**args)
    super(args)
    
    encoded_card_name = card_name_url_encode(args[:name])
    edition_abbreviation = VintageEditions[args[:edition]] || AllEditionsStandardCodes[args[:edition]]
    colors = args[:colors]

    self.img_url = "#{BASE_URL}/#{encoded_card_name}%2B%255B#{edition_abbreviation}%255D.jpg"
    self.color = colors.size == 1 ? colors[0] : colors.size > 1 ? 'Gold' : 'Colorless'
  end

  #double encoding
  def card_name_url_encode(card_name)
    name = I18n.transliterate(card_name)
    CGI.escape(CGI.escape(name))
  end

  #returns a sorted list of unique card names
  def self.all_card_names
    cache_key = "all_unique_card_names#{Time.now.day}"

    Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      Card.distinct.pluck(:name).sort!
    end
  end

  #piggybacks on .all_card_names method; same return value only in JSON form; for card search autocomplete feature
  def self.all_card_names_json
    cache_key = "all_unique_card_names_json#{Time.now.day}"

    Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      Card.all_card_names.to_s
    end
  end

  #for the autocomplete feature for selecting cards for a collection by name and edition. returns json (array.to_s)
  def self.all_card_and_edition_names
    cache_key = "all_card_names_with_editions#{Time.now.day}"
    names_and_editions = Rails.cache.fetch(cache_key, expires_in: 24.hours) do
      Card.pluck(:name, :edition).to_s
    end
  end

  #binary search for a card name matching user's input. ignoring case
  #returns the proper name of the card if found, not a lowercase version.
  def self.namesearch(search, case_agnostic = false)    
    unless case_agnostic
      return Card.all_card_names.bsearch { | name | search <=> name }
    else
      search = search.downcase
      Card.all_card_names.bsearch { | name | search <=> name.downcase }
    end
  end

  #Card search feature

  #if user used the autocomplete feature to select an exact match, return the first print of the given card
  #otherwise, check for an exact match by ignoring the input's casing. Return the match if one was found.
  #if no exact matches, we check card names against a downcased, Regex-escaped search, skipping nonmatching card names
  def self.search(search)
    exact_match = Card.find_by(name: search, reprint: false)

    if exact_match.nil?
      name        = self.namesearch(search, true)
      exact_match = Card.find_by(name: name, reprint: false) if name
    end

    return { name: exact_match.name, edition: exact_match.edition } if exact_match

    matches = []
    partial_matches = []
    downcased_search = search.downcase
    escaped_search = Regexp.escape(search)
    target = (/#{escaped_search}/i)

    Card.where(reprint: false).pluck(:edition, :name, :img_url).each do | edition, name, img_url |
      next unless name.match?(target)

      if name.split.any? { | word | word.downcase == downcased_search } 
        matches << [ edition, name, img_url ]
      else 
        partial_matches << [ edition, name, img_url ]
      end
    end
    #return list of full-word and partial-word matches if no exact matches were found
    [ matches, partial_matches ].map! { | array | array.sort_by! { | _, name | name } } 
  end
  
end