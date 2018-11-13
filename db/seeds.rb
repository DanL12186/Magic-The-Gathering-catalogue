# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Card.create(name: "Mox Diamond", edition: "Stronghold", artist: "Dan Frazier", card_type: "Artifact", mana: ["0"], rarity: "Rare", effects: "When Mox Diamond comes into play, discard a land card or sacrifice Mox Diamond.", activated_abilities: ["Tap to add one mana of any color to your mana pool. Play this ability as a mana source."])

Card.create(name: "Black Lotus", edition: "Alpha", artist: "Christopher Rush", card_type: "Artifact", subtypes: [], mana: ["0"], restricted: true, rarity: "Rare", abilities: ["Sacrifice Black Lotus: Adds 3 mana of any single color of your choice to your mana pool, then is discarded. Tapping this artifact can be played as an interrupt."], site_notes: "The most iconic card in the game, Black Lotus can give a game-winning three extra mana on turn one. In good enough condition, it can sell for tens or hundreds of thousands of dollars in Alpha or Beta format.") 

Card.create(name: "Sol Ring", edition: "Alpha", artist: "Mark Tedin", card_type: "Artifact", subtypes: [], mana: ["1"], rarity: "Uncommon", activated_abilities: ["Tap to add 2 colorless mana to your mana pool. This ability is played as an interrupt."])

Card.create(name: "Ertai, Wizard Adept", edition: "Exodus", artist: "Terese Nielsen", card_type: "Creature", subtypes: ["Wizard"], colors: ["Blue"], mana: ["2", "Blue", "Blue"], rarity: "Rare", power: 1, toughness: 1, flavor_text: "Was that <i>it</i>? -Ertai, wizard adept", activated_abilities: ["Two colorless mana and two blue mana, tap: Counter target spell. Play this ability as an interrupt."])

Card.create(name: "Wrath of God", edition: "Beta", rarity: "Rare", colors: ["White"], artist: "Quinton Hoover", card_type: "Sorcery", mana: ["2","White","White"],effects: "All creatures in play are buried.")

Card.create(name: "Icy Manipulator", edition: "Alpha", rarity: "Uncommon", artist: "Douglas Shuler", mana: ["4"], card_type: "Artifact", subtypes: ["Mono Artifact"], activated_abilities: ["1: You may tap any land, creature, or artifact in play on either side."])

Card.create(name: "Tropical Island", card_type: "Land", subtypes: ["Forest", "Island", "Nonbasic Land"], artist: "Jesper Myfors", rarity: "Rare", activated_abilities: ["Tap to add either one green or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Volcanic Island", card_type: "Land", subtypes: ["Mountain", "Island", "Nonbasic Land"], artist: "Brian Snoddy", rarity: "Rare", activated_abilities: ["Tap to add either one red or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Bayou", card_type: "Land", subtypes: ["Swamp", "Forest", "Nonbasic Land"], artist: "Jasper Myfors", rarity: "Rare", activated_abilities: ["Tap to add either one green or black mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Taiga", card_type: "Land", subtypes: ["Mountain", "Forest", "Nonbasic Land"], artist: "Rob Alexander", rarity: "Rare", activated_abilities: ["Tap to add either one green or red mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Tundra", card_type: "Land", subtypes: ["Plains", "Island", "Nonbasic Land"], artist: "Jesper Myfors", rarity: "Rare", activated_abilities: ["Tap to add either one white or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Natural Order", edition: "Visions", mana: ["2", "Green", "Green"], card_type: "Sorcery", artist: "Terese Nielsen", flavor_text: "...but the price of Mangara's freedom was Asmira's life.", 
effects: "Sacrifice a green creature. Search your library for a green creature card and put it onto the battlefield. Then shuffle your library.", rarity: "Rare")

Card.create(name: "Lotus Petal", activated_abilities: ["Sacrifice Lotus Petal: Add one mana of any color to your mana pool."], mana: ["0"], artist: "April Lee", rarity: "Common", edition: "Tempest")

Card.create(name: "Serra Angel", edition: "Unlimited", mana: ["3", "White", "White"], artist: "Douglas Schuler", power: 4, toughness: 4, abilities: ["Flying", "Vigilance"], rarity: "Uncommon", flavor_text: "Born with wings of light and a sword of faith, this heavenly incarnation embodies both fury and purity.")

Card.create(name: "Disrupting Scepter", edition: "Beta", artist: "Dan Frazier", card_type: "Artifact", mana: ["3"], activated_abilities: ["3: Target opponent discards a card of their choice. Can only be used during your turn."], rarity: "Rare")

Card.create(name: "Regrowth", mana: ["1","Green"], card_type: "Sorcery", edition: "Revised", artist: "Dameon Willich", activated_abilities: [], abilities: [], effects: "Bring any card from your graveyard into your hand.", rarity: "Uncommon")

Card.create(name: "Reverse Damage", mana: ["1", "White", "White"], edition: "Alpha", rarity: "Rare", artist: "Dameon Willich", card_type: "instant", effects: "All damage you have taken from any one source this turn is added to your life total instead of subtracted from it.")

Card.create(name: "Ali from Cairo", mana: ["2", "Red", "Red"], edition: "Arabian Nights", rarity: "Rare", artist: "Mark Poole", card_type: "Creature", effects: "While Ali is in play, damage that would reduce you to less than 1 life lowers you to 1 life. All further damage is prevented.", power:0, toughness:1)

Card.create(name: "Lake of the Dead", card_type: "Land", effects: "When Lake of the Dead comes into play, sacrifice a swamp, or bury Lake of the Dead.", activated_abilities: ["Tap to add one black mana to your mana pool.", "Tap, sacrifice Lake of the Dead: Add four black mana to your mana pool."], artist: "Pete Venters", rarity: "Rare", edition: "Alliances")

Card.create(name: "Mox Emerald", edition: "Beta", artist: "Dan Frazier", card_type: "Artifact", subtypes: ["Mono Artifact"], mana: ["0"], restricted: true, rarity: "Rare", 
abilities: [], activated_abilities: ["Add 1 green mana to your mana pool. Tapping this artifact can be played as an interrupt."])

Card.create(name:"Ring of Immortals", edition: "Legends", card_type: "Artifact", mana: ["5"], activated_abilities: ["3, tap: Counters target interrupt or enchantment. Can only counter spells which target a permanent under your control. This ability is played as an interrupt."], artist: "Melissa Benson", rarity: "Rare")

Card.create(name: "City of Brass", edition: "Arabian Nights", artist: "Mark Tedin", card_type: "Land", rarity: "Rare", activated_abilities: ["Tap to add 1 mana of any color to your mana pool. You suffer 1 damage whenever City of Brass becomes tapped."])

Card.create(name: "Fireball", edition: "Beta", artist: "Mark Tedin", card_type: "Sorcery", subtypes: [], colors: ["X", "Red"], mana: ["X", "Red"], effects: "Fireball does X damage total, divided evenly (rounded down) among any number of targets. Pay 1 extra mana for each target beyond the first.", rarity: "Common")

Card.create(name: "Concordant Crossroads", edition: "Legends", artist: "Amy Weber", card_type: "Enchantment", colors: ["Green"], mana: ["Green"], rarity: "Rare", effects: "Creatures may attack or use abilities that include tapping in their activation cost as soon as they come into play on their controller's side.")

Card.create(name: "Birds of Paradise", edition: "Revised", artist: "Mark Poole", card_type: "Creature", subtypes: ["Bird"], colors: ["Green"], mana: ["Green"],  power: 0, toughness: 1, rarity: "Rare", abilities: ["Flying"], activated_abilities: ["Tap: Add one mana of any color to your mana pool."])

Card.create(name: "Phyrexian Dreadnought", edition: "Mirage", artist: "Pete Venters", card_type: "Artifact Creature", subtypes: ["Dreadnought"], mana: ["1"], power: 12, toughness: 12, rarity: "Rare", abilities: ["Trample"], effects: "When Phyrexian Dreadnought comes into play, sacrifice any number of creatures with total power of 12 or more, or bury Phyrexian Dreadnought")

Card.create(name: "Shivan Dragon", edition: "Revised", artist: "Melissa Benson", card_type: "Creature", subtypes: ["Dragon"], mana: ["4", "Red", "Red"], power: 5, toughness: 5, rarity: "Rare", abilities: ["Flying"], activated_abilities: ["R: +1/+0 until end of turn"], flavor_text: "While it's true most Dragons are cruel, the Shivan Dragon seems to take particular glee in the misery of others, often tormenting its victims much like a cat plays with a mouse before delivering the final blow.")

Card.create(name: "Mox Ruby", edition: "Alpha", artist: "Dan Frazier", card_type: "Artifact", subtypes: ["Mono Artifact"], mana: ["0"], restricted: true, rarity: "Rare", activated_abilities: ["Add 1 red mana to your mana pool. Tapping this artifact can be played as an interrupt."])

Card.create(name: "Mox Pearl", edition: "Beta", artist: "Dan Frazier", card_type: "Artifact", subtypes: ["Mono Artifact"], mana: ["0"], restricted: true, rarity: "Rare", activated_abilities: ["Add 1 white mana to your mana pool. Tapping this artifact can be played as an interrupt."])

Card.create(name: "Mox Sapphire", edition: "Beta", artist: "Dan Frazier", card_type: "Artifact", subtypes: ["Mono Artifact"], mana: ["0"], restricted: true, rarity: "Rare", activated_abilities: ["Add 1 blue mana to your mana pool. Tapping this artifact can be played as an interrupt."])

Card.create(name: "Mox Jet", edition: "Beta", artist: "Dan Frazier", card_type: "Artifact", subtypes: ["Mono Artifact"], mana: ["0"], restricted: true, rarity: "Rare", activated_abilities: ["Add 1 black mana to your mana pool. Tapping this artifact can be played as an interrupt."])

Card.create(name: "Time Warp", edition: "Tempest", artist: "Pete Venters", card_type: "Sorcery", colors: ["Blue"], mana: ["3", "Blue", "Blue"], rarity: "Rare", effects: "Target player takes an extra turn after this one.", flavor_text: "Let's do it again! -Squee,Goblin Captain hand")

Card.create(name: "Revelation", edition: "Legends", artist: "Kaja Foglio", mana: ["Green"], card_type: "Enchantment", subtypes: ["Enchant World", "Global Enchantment"], rarity: "Rare", effects: "All players play with the cards in their hands face down on the table.", flavor_text: '"Many are in high place, and of renown: but mysteries are revealed unto the meek." --Ecclesiastes, 3:19')

Card.create(name: "Force of Nature", power: 8, toughness: 8, mana: ["2", "Green","Green","Green","Green"], artist: "Douglas Schuler", abilities: ["Trample"], effects: "You must pay four forests at the beginning of your upkeep or Force of Nature does 8 damage to you.", card_type: "Creature", subtypes: ["Force"], edition: "Unlimited")

Card.create(name: "Ancestral Recall", mana: ["Blue"], effects: "Draw three cards or force opponent to draw three cards.", artist: "Mark Poole", edition: "Unlimited", reserved: true, restricted: true, card_type: "Instant")

Card.create(name: "Forcefield", edition: "Unlimited", artist: "Dan Frazier", card_type: "Artifact", subtypes: [], mana: ["3"], restricted: true, reserved: true, rarity: "Rare", activated_abilities: ["1: Lose only 1 life to an unblocked creature."])

Card.create(name: "Lightning Bolt", edition: "Unlimited", artist: "Christopher Rush", card_type: "Instant", effects: "Lightning bolt does 3 damage to one target", mana: ["Red"])

Card.create(name: "Hurkyl's Recall", artist: "Néné Thomas", edition: "Revised", mana: ["1","Blue"], effects: "Return all artifacts target player owns to his or her hand.", card_type: "Instant", rarity: "Rare")

Card.create(name: "Storm Seeker", edition: "Legends", artist: "Mark Poole", mana: ["3", "Green"], card_type: "Instant", effects: "Storm Seeker does 1 damage to opponent for each card in their hand.", rarity: "Uncommon")

Card.create(name: "Underground River", card_type: "Land", subtypes: ["Nonbasic Land"], activated_abilities: ["Tap to add one colorless mana to your mana pool.", "Tap to add either one blue or black mana to your mana pool. You lose one life."], edition: "Ice Age", rarity: "Rare")

Card.create(name: "Lim-Dul's Paladin", card_type: "Creature", subtypes: ["Knight"], abilities: ["Trample"], effects: "At the beginning of your upkeep, you may discard a card. If you don't, sacrifice Lim-Dûl's Paladin and draw a card. Whenever Lim-Dûl's Paladin becomes blocked, it gets +6/+3 until end of turn. Whenever Lim-Dûl's Paladin attacks and isn't blocked, it assigns no combat damage this turn and defending player loses 4 life. This cannot be prevented.", rarity: "Uncommon", power: 0, toughness: 3, edition: "Alliances", artist: "Christopher Rush", mana: [2, "Black", "Red"] )

Card.create(artist: "Pete Venters", name: "Survival of the Fittest", edition: "Exodus", mana: ["1", "Green"], card_type: "Enchantment", activated_abilities: ["Tap one green mana, discard a card: search your library for a creature card, reveal it and put it into your hand."], rarity: "Rare", reserved: true)

Card.create(name: "Chromium", edition: "Legends", power: 7, toughness: 7, abilities: ["Flying", "Rampage: 2"], effects: "Chromium is buried unless you pay a swamp, island and plains.", artist: "Edward Beard Jr.", rarity: "Rare", mana: ["2", "Black", "Black", "Blue", "Blue", "White", "White"], card_type: "Creature", subtypes: ["Dragon", "Elder", "Legend"] )

Card.create(name:"Balduvian Horde", edition: "Alliances", artist: "Brian Snoddy", power: 5, toughness: 5, mana: ["2", "Red", "Red"], rarity: "Rare", effects: "When played, discard a card at random or bury Balduvian Horde.")

Card.create(name: "Juzam Djinn", edition: "Arabian Nights", mana: ["2", "Black", "Black"], power: 5, toughness: 5, flavor_text:"\Expect my visit when the darkness comes. The night I think is best for hiding all.\" -Ouallada.", effects: "Juzám Djinn does 1 damage to you during your upkeep.", card_type: "Creature", subtypes: ["Djinn"], artist: "Mark Tedin", rarity: "Rare", reserved: true)

Card.create(name: "Dark Ritual", card_type: "Instant", mana: ["Black"], effects: "Add three black mana to your mana pool.", edition: "Tempest", artist: "Ken Meyer Jr.", rarity:"Common", flavor_text: "\"If there is such a thing as too much power, I have not discovered it.\" -Volrath" )

Card.create(name: "Gauntlet of Might", artist: "Christopher Rush", card_type: "Artifact", edition: "Beta", mana: ["4"], effects: "All red creatures get +1/+1. All mountains produce an additional red mana.", rarity: "Rare", reserved: true)

Card.create(name: "Kird Ape", power: 1, toughness: 1, mana: ["Red"], effects: "Kird ape gets +1/+2 as long as you control any forests", artist: "Ken Meyer Jr.", rarity: "Common", edition: "Revised")

Card.create(name: "Ancient Tomb", edition: "Tempest", artist: "Colin MacNeil", rarity: "Uncommon", card_type: "Land", subtypes: ["Nonbasic Land"], activated_abilities: ["Tap: Add two colorless mana to your mana pool. Ancient Tomb deals 2 damage to you."], flavor_text: "There is no glory to be gained in the kingdom of the dead. -Vec tomb inscription")

Card.create(name: "Monsoon", effects: "At the beginning of each player's end step, tap all untapped Islands that player controls and Monsoon deals 1 damage to that player for each island tapped this way.", flavor_text: "\No one in her right mind would venture off the coast of Kjeldor during this season.\" -Disa The Restless, Journal Entry", card_type: "Enchantment", mana: ["2", "Red", "Green"], edition: "Ice Age", rarity: "Rare", artist: "NéNé Thomas") 

Card.create(name: "Lion's Eye Diamond", activated_abilities: "Sacrifice Lion's Eye Diamond, Discard your hand: Add three mana of any one color to your mana pool. Activate this ability only any time you could cast an instant.", mana: ["0"], edition: "Mirage", artist: "Margaret Organ-Kean", card_type: "Artifact", flavor_text: "Held in the lion's eye.\n -Zhalfirin saying, meaning \"caught in the moment of crisis\"", rarity: "Rare", reserved: true)

Card.create(name: "Primal Rage", artist: "Brian Snoddy", edition: "Stronghold", mana: ["1", "Green"], effects: "All creatures you control gain trample", card_type: "Enchantment", flavor_text: "\"Charge!\" A great cry went out, and countless elves and Vec soldiers charged up the mountain. Their fury and passion hid the fact that they were horribly outnumbered.", rarity: "Uncommon")

Card.create(name: "Psychic Venom", card_type: "Enchantment", subtypes: ["Enchant Land"], artist: "Brian Snoddy",edition: "Unlimited", mana: ["1", "Blue"], effects: "Whenever target land is tapped, Psychic Venom deals 2 damage to that land's controller.", rarity: "Common")
#rare cards from homelands expansion
# cards = MTG::Card.where(set: 'hml').where(rarity: "Rare").all

#easier view... cards.map { | card | JSON.parse(card.serialize) }

# cards.select { | card | card.rarity == "Rare" }.each do | card | 
#     Card.new(name: card.name, rarity: card.rarity, subtypes: card.subtypes || [], card_type: card.types, power: card.power ? card.power[0].to_i : nil, artist: card.artist, edition: "Homelands", toughness: card.toughness ? card.toughness[0].to_i : nil, flavor_text: card.flavor)
# end

#or if a ruby obj

# Card.new(name: card['name'], rarity: card['rarity'], subtypes: card['subtypes'], card_type: card['types'][0], power: card['power'] ? card['power'][0].to_i : nil, artist: card['artist'], edition: card['setName'], toughness: card['toughness'] ? card['toughness'][0].to_i : nil, flavor_text: card['flavor'])
