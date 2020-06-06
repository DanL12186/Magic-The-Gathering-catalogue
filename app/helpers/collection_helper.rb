module CollectionHelper
  def calculate_collection_value(collection)
    value = collection.collections_cards.map do | collection_card | 
              card = collection_card.card
              card_kingdom_price = card.prices[1].to_f || 0  
              collection_card.copies * card_kingdom_price
            end.sum.round(2)

    number_with_delimiter(value)
  end


  def display_collection(collection)
    collection.collections_cards.map do | collection_card |
      card = collection_card.card
      name, edition, price, copies = [card.name, card.edition, card.prices[1], collection_card.copies]

      "<li>#{copies}x #{link_to(name, card_path(edition, name))} - $#{price}</li>"
    end.join.html_safe
  end

end