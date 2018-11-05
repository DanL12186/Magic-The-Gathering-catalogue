module Cards
  require 'cgi'

  def card_name_url_encode(card_name) #double encoding
    CGI.escape(CGI.escape(card_name)) + "%2B%255B"
  end

  Editions = {
    "Alpha" => "LEA",
    "Beta" => "LEB",
    "Unlimited" => "2ED",
    "Revised" => "3ED",
    "Fourth Edition" => "4ED",
    "Fifth Edition" => "5ED",
    
    "Arabian Nights" => "ARN",
    "Antiquities" => "ATQ",
    "Legends" => "LEG",
    "The Dark" => "DRK",
    "Fallen Empires" => "FEM",

    "Ice Age" => "ICE",
    "Homelands" => "HML",
    "Alliances" => "ALL",

    "Mirage" => "MI",
    "Visions" => "VI",
    "Weatherlight" => "WL",

    "Tempest" => "TE",
    "Stronghold" => "ST",
    "Exodus" => "EX"
  }
  
end