class EditionsController < ApplicationController
  def index
  end

  def show
    @edition = Edition.find_by(name: params[:name])
  end

  def open_booster_pack
    @ordered_editions = Edition.where.not(cards_per_pack: nil).pluck(:name).sort_by(&SET_NAMES_IN_CHRONOLOGICAL_ORDER)
    
    @edition_name = params[:edition] || "Revised"
    @edition  = Edition.find_by(name: @edition_name)
    @booster_pack = generate_booster(@edition_name)
  end

  private

    def generate_booster(edition_name)
      all_cards = Card.select(:name, :prices, :edition, :img_url, :rarity, :card_number).where(edition: edition_name)      
      mana      = Set.new(['Swamp', 'Island', 'Mountain', 'Forest', 'Plains'])

      cards     = edition_name.match?(/Arabian|Alpha|Beta|Unlimited|Revised/) ? all_cards.to_a : all_cards.reject { | card | mana.include?(card.name) }

      #ignore the back face of flip cards
      cards.reject! { | card | card.card_number.match?('b') }

      commons   = cards.select { | card | card.rarity == 'Common' }
      uncommons = cards.select { | card | card.rarity == 'Uncommon' }
      rares     = cards.select { | card | card.rarity == 'Rare' }
      mythics   = cards.select { | card | card.rarity == 'Mythic' } if @edition.mythics?

      booster_pack = []

      booster_pack << commons.sample(@edition.commons_per_pack)
      booster_pack << uncommons.sample(@edition.uncommons_per_pack)

      #1/8 chance of getting a mythic instead of rare
      if @edition.mythics? && rand(1..8) == 8
        booster_pack << mythics.sample
      else
        booster_pack << rares.sample
      end
      
      booster_pack.flatten
    end

end
