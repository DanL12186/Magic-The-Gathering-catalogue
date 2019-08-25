module EditionHelper

  def get_edition_image_file(edition_name, rarity)
    "editions/#{edition_name.downcase} #{rarity.downcase}".sub(/ common/, '')
  end

  def roll_foil?(edition)
    Date.parse(edition.release_date) >= Date.parse('1999-02-15') && rand(1..67) == 67
  end
  
end
