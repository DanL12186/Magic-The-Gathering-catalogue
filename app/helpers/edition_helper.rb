module EditionHelper

  def get_edition_image_file(edition_name, rarity)
    "editions/#{edition_name.downcase} #{rarity.downcase}".sub(/ common/, '')
  end
  
end
