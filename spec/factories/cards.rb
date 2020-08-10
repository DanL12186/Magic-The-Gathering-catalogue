FactoryBot.define do
  factory :card do

    #specific for use with Rails models which override .initialize
    initialize_with { 
      card_attributes = attributes.merge(
        name: "#{Faker::Games::ElderScrolls.creature} #{Faker::Games::DnD.species}",
        edition: "Alpha",
        artist: Faker::Name.name,
        card_type: ["Artifact", "Creature", "Enchantment", "Instant", "Sorcery"].sample,
        rarity: ["Rare", "Uncommon", "Common"].sample,
        multiverse_id: rand(1e6),
        mana: ["3"],
        subtypes: [],
        color: "Colorless",
        colors: [],
        img_url: '',
        cropped_img: '',
        card_number: "#{rand(1000)}",
      )

      Card.new(card_attributes)
    }
  end
end