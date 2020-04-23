module CollectionHelper
  def calculate_collection_value(collection)
    collection.collections_cards.map do | collection_card | 
      card = collection_card.card
      card_kingdom_price = card.prices[1].to_f || 0
      collection_card.copies * card_kingdom_price
    end.sum.round(2)
  end


  def display_collection(collection)
    collection.collections_cards.map do | collection_card |
      card = collection_card.card
      "<li> #{collection_card.copies}x #{card.name} - $#{card.prices[1]} </li>"
    end.join.html_safe
  end

end