class CardSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :rarity, :edition, :price, :color, :card_type, :converted_mana_cost, :hi_res_img, :multiverse_id
end
