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

Card.create(name: "Tropical Island", card_type: "Land", subtypes: ["Forest", "Island", "Nonbasic Land"], artist: "Jesper Myrfors", rarity: "Rare", activated_abilities: ["Tap to add either one green or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Volcanic Island", card_type: "Land", subtypes: ["Mountain", "Island", "Nonbasic Land"], artist: "Brian Snoddy", rarity: "Rare", activated_abilities: ["Tap to add either one red or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Bayou", card_type: "Land", subtypes: ["Swamp", "Forest", "Nonbasic Land"], artist: "Jasper Myrfors", rarity: "Rare", activated_abilities: ["Tap to add either one green or black mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Scrubland", card_type: "Land", subtypes: ["Swamp", "Plains", "Nonbasic Land"], artist: "Jasper Myrfors", rarity: "Rare", activated_abilities: ["Tap to add either one white or black mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Taiga", card_type: "Land", subtypes: ["Mountain", "Forest", "Nonbasic Land"], artist: "Rob Alexander", rarity: "Rare", activated_abilities: ["Tap to add either one green or red mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Tundra", card_type: "Land", subtypes: ["Plains", "Island", "Nonbasic Land"], artist: "Jesper Myrfors", rarity: "Rare", activated_abilities: ["Tap to add either one white or blue mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Plateau", card_type: "Land", subtypes: ["Plains", "Mountain", "Nonbasic Land"], artist: "Drew Tucker", rarity: "Rare", activated_abilities: ["Tap to add either one white or red mana to your mana pool"], edition: "Unlimited" )

Card.create(name: "Natural Order", edition: "Visions", mana: ["2", "Green", "Green"], card_type: "Sorcery", artist: "Terese Nielsen", flavor_text: "...but the price of Mangara's freedom was Asmira's life.", 
effects: "Sacrifice a green creature. Search your library for a green creature card and put it onto the battlefield. Then shuffle your library.", rarity: "Rare")

Card.create(name: "Lotus Petal", activated_abilities: ["Sacrifice Lotus Petal: Add one mana of any color to your mana pool."], mana: ["0"], artist: "April Lee", rarity: "Common", edition: "Tempest")

Card.create(name: "Serra Angel", edition: "Unlimited", mana: ["3", "White", "White"], artist: "Douglas Schuler", power: 4, toughness: 4, abilities: ["Flying", "Vigilance"], card_type: "Creature", rarity: "Uncommon", flavor_text: "Born with wings of light and a sword of faith, this heavenly incarnation embodies both fury and purity.")

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

Card.create(name: "Nicol Bolas", edition: "Legends", power: 7, toughness: 7, abilities: ["Flying"], effects: "An opponent damaged by Nicol Bolas must discard entire hand. Ignore this effect if opponent has no cards left in hand. Pay UBR during your upkeep or Nicol Bolas is buried.", artist: "Edward Beard Jr.", rarity: "Rare", mana: ["2", "Black", "Black", "Blue", "Blue", "Red", "Red"], card_type: "Creature", subtypes: ["Dragon", "Elder", "Legend"] 

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

Card.create(name: "Aladdin's Ring", edition: "Revised", mana: ["8"], artist: "Dan Frazier", card_type: "Artifact", activated_abilities: ["8, tap:  Aladdin's Ring deals 4 damage to any target."], flavor_text: "\"After these words the magician drew a ring off his finger, and put it on one of Aladdin's, saying: ‘It is a talisman against all evil, so long as you obey me.'\" The Arabian Nights, Junior Classics trans.", rarity: "Rare")

Card.create(name: "Channel", edition: "Unlimited", effects: "Until end of turn, any time you could activate a mana ability, you may pay 1 life. If you do, add one colorless mana to your mana pool.", rarity: "Uncommon", artist: "Richard Thomas", mana: ["Green", "Green"])

Card.create(name: "Ring of Ma'rûf", mana: ["5"], edition: "Arabian Nights", activated_abilities: ["5, tap: Exile Ring of Ma'rûf: The next time you would draw a card this turn, instead choose a card you own from outside the game and put it into your hand."], artist: "Dan Frazier", rarity: "Rare", reserved: true, card_type: "Artifact")

Card.create(name: "Sisay's Ring", edition: "Visions", artist: "Donato Giancola", mana: ["4"], activated_abilities: ["Tap to add two colorless mana to your mana pool."], flavor_text: "\"With this ring, you have friends in worlds you've never heard of.\" -Sisay, Captain of the Weatherlight", card_type: "Artifact", rarity: "Common")

Card.create(name: "Sorceress Queen", artist: "Kaja Foglio", edition: "Arabian Nights", activated_abilities: "Tap: target creature other than Sorceress Queen has base power and toughness 0/2 until end of turn.", power: 1, toughness: 1, rarity: "Uncommon", card_type: "Creature", subtypes: ["Human", "Wizard"], mana: ["1", "Black", "Black"])

Card.create(name: "Bird Maiden", edition: "Arabian Nights", mana: ["2", "Red"], abilities: ["Flying"], card_type: "Creature", subtypes: ["Human", "Bird"], flavor_text: "\"Four things that never meet do here unite To shed my blood and to ravage my heart, A radiant brow and tresses that beguile And rosy cheeks and a glittering smile.\"The Arabian Nights, trans. Haddawy",power: 1, toughness: 2, artist: "Kaja Foglio", rarity: "Common")

Card.create(name: "Shahrazad", edition: "Arabian Nights", artist: "Kaja Foglio", mana: ["White", "White"], card_type: "Sorcery", effects: "Players play a Magic subgame, using their libraries as their decks. Each player who doesn't win the subgame loses half their life, rounded up.", rarity: "Rare", restricted: true, reserved: true)

Card.create(name: "Al-abara's Carpet", edition: "Legends", activated_abilities: ["5, tap: Prevent all damage that would be dealt to you this turn by attacking creatures without flying."], flavor_text: "Al-abara simply laughed and lifted one finger, and the carpet carried her high out of our reach.", mana: ["5"], card_type: "Artifact", artist: "Kaja Foglio", rarity: "Rare", reserved: true)

Card.create(name: "Kismet", edition: "Legends", artist: "Kaja Foglio", card_type: "Enchantment", mana: ["3", "White"], rarity: "Rare", effects: "Artifacts, creatures, and lands your opponents control enter the battlefield tapped.", flavor_text: "\"Make people wait for what they want, and you have power over them. This is as true for merchants and militia as it is for cooks and couples.\" -Gwendolyn Di Corci")

Card.create(name: "North Star", edition: "Legends", artist: "Kaja Foglio", rarity: "Rare", activated_abilities: ["4, tap: For one spell this turn, you may spend mana as though it were mana of any type to pay that spell's mana cost. (Additional costs are still paid normally.)"], card_type: "Artifact", reserved: true, mana: ["4"])

Card.create(name: "Winter Blast", edition: "Legends", artist: "Kaja Foglio", rarity: "Rare", activated_abilities: [], card_type: "Sorcery", mana: ["X", "Green"], effects: "Tap X target creatures. Winter Blast deals 2 damage to each of those creatures with flying.", flavor_text: "\"Blow, winds, and crack your cheeks rage blow\" -William Shakespeare, King Lear")

Card.create(name: "Mahamoti Djinn", edition: "Beta", artist: "Dan Frazier", power: 5, toughness: 6, mana: ["4", "Blue", "Blue"], abilities: ["Flying"], card_type: "Creature", subtypes: ["Djinn"], flavor_text: "Of royal blood amongst the spirits of the air, the Mahamoti Djinn rides on the wings of the winds. As dangerous in the gambling hall as he is in battle, he is a master of trickery and misdirection.", rarity: "Rare")

Card.create(name: "Aladdin's Lamp", edition: "Arabian Nights", card_type: "Artifact", artist: "Mark Tedin", mana: ["5", "5"], activated_abilities: ["X, tap: The next time you would draw a card this turn, instead look at the top X cards of your library, put all but one of them on the bottom of your library in a random order, then draw a card."], rarity: "Rare")

Card.create(name: "Red Ward", edition: "Alpha", artist: "Dan Frazier", rarity: "Uncommon", mana: ["White"], card_type: "Enchantment", effects: "Target creature gains protection from red.")

Card.create(name: "White Knight", edition: "Alpha", artist: "Daniel Gelon", rarity: "Uncommon", mana: ["White", "White"], card_type: "Creature", abilities: ["First strike", "Protection from black"], flavor_text: "Out of the blackness and stench of the engulfing swamp emerged a shimmering figure. Only the splattered armor and ichor-stained sword hinted at the unfathomable evil the knight had just laid waste.", power: 2, toughness: 2, subtypes: ["Human", "Knight"])

Card.create(name: "Black Knight", edition: "Alpha", artist: "Jeff A. Menges", rarity: "Uncommon", mana: ["Black", "Black"], card_type: "Creature", abilities: ["First strike", "Protection from white"], flavor_text: "Battle doesn't need a purpose; the battle is its own purpose. You don't ask why a plague spreads or a field burns. Don't ask why I fight.", power: 2, toughness: 2, subtypes: ["Human", "Knight"])

Card.create(name: "Chain Lightning", edition: "Legends", artist: "Sandra Everingham", rarity: "Common", card_type: "Sorcery", mana: ["Red"], effects: "Chain Lightning deals 3 damage to any target. Then that player or that permanent's controller may pay two mountains. If the player does, they may copy this spell and may choose a new target for that copy.")

Card.create(name: "Demonic Tutor", edition: "Beta", artist: "Douglas Schuler", mana: ["1", "Black"], card_type: "Sorcery", effects: "You may search your library for one card and take it into your hand. Reshuffle your library afterwards.", restricted: true, rarity: "Uncommon")

Card.create(name: "Summer Bloom", edition: "Visions", artist: "Nicola Leonard", rarity: "Uncommon", card_type: "Sorcery", effects: "You may play up to three additional lands this turn.", flavor_text: "\"Our love is like the river in the summer season of long rains. \/ For a little while it spilled its banks, flooding the crops in the fields.\" —\"Love Song of Night and Day\"", mana: ["1", "Green"])

Card.create(name: "Two-Headed Giant of Foriys", edition: "Unlimited", artist: "Anson Maddocks", abilities: ["Trample", "Can block up to two creatures"], flavor_text: "None know if this Giant is the result of aberrant magics, Siamese twins, or a mentalist's schizophrenia.", rarity: "Rare", power: 4, toughness: 4, mana: ["4", "Red"], card_type: "Creature", subtypes: ["Giant"], reserved: true)

Card.create(name: "Mind Twist", edition: "Revised", artist: "Julie Baroh", rarity: "Rare", mana: ["X", "Black"], card_type: "Sorcery", effects: "Target player discards X cards at random.")

Card.create(name: "Serendib Efreet", edition: "Revised", artist: "Jesper Myrfors", power:3, toughness: 4, mana: ["2", "Blue"], effects: "During your upkeep, Serendib Efreet deals 1 damage to you.", rarity: "Rare", card_type: "Creature", subtypes: ["Efreet"], site_note: "The English version of this card was accidentally printed with the color and image of the Iff-Binh Efreet from Arabian Nights.")

Card.create(name: "Grinning Totem", edition: "Mirage", artist: "Donato Giancola", mana: ["4"], card_type: "Artifact", activated_abilities: ["2, Tap: Sacrifice Grinning Totem: Search target opponent's library for a card and exile it. Then that player shuffles their library. Until the beginning of your next upkeep, you may play that card. At the beginning of your next upkeep, if you haven't played it, put it into its owner's graveyard."], rarity: "Rare")

Card.create(name: "Ball Lightning", edition: "The Dark", artist: "Quinton Hoover", mana: ["Red", "Red", "Red"], card_type: "Creature", subtypes: ["Elemental"], power: 6, toughness: 1, rarity: "Rare", abilities: ["Trample", "Haste"], effects: "Bury Ball Lightning at end of turn.")

Card.create(name: "Songs of the Damned", edition: "Ice Age", mana: ["Black"], artist: "Pete Venters", card_type: "Instant", effects: "Add one black mana to your mana pool for each creature in your graveyard.", flavor_text: "Not wind, but the breath of the dead.", rarity: "Common")
    #rare cards from homelands expansion
# cards = MTG::Card.where(set: 'hml').where(rarity: "Rare").all

#easier view... cards.map { | card | JSON.parse(card.serialize) }
#cards.each { | card | card.representable_attrs = nil; card.rulings = nil }

# cards.select { | card | card.rarity == "Rare" }.each do | card | 
#     Card.new(name: card.name, rarity: card.rarity, subtypes: card.subtypes || [], card_type: card.types, power: card.power ? card.power[0].to_i : nil, artist: card.artist, edition: "Homelands", toughness: card.toughness ? card.toughness[0].to_i : nil, flavor_text: card.flavor)
# end

#or if a ruby obj

# Card.new(name: card['name'], rarity: card['rarity'], subtypes: card['subtypes'], card_type: card['types'][0], power: card['power'] ? card['power'][0].to_i : nil, artist: card['artist'], edition: card['setName'], toughness: card['toughness'] ? card['toughness'][0].to_i : nil, flavor_text: card['flavor'])
