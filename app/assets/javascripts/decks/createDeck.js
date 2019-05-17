$(document).on('turbolinks:load', function() {
  
  //clear autocomplete form on refresh
  if (this.getElementById('deckCardFind')) {
    this.getElementById('deckCardFind').value = ''
  }

  let cardNames,
      lastMatch;

  //for some reason, form and head auth tokens don't match until refresh, this is a fix
  const railsAuthenticityToken = $("head meta")[1].content,
        formAuthenticityToken  = $("#new_deck input")[1]

  $('#deckCardFind').on('focus', () => {
    if (!cardNames) {
      const response = $.get('/cards/card_names');
      response.done(names => cardNames = names.sort())
    }
  });

  function addCardToList(event, cardName, copies) {
    event.preventDefault();

    const addedCardList = document.getElementById('decks_cards_list')
    ,     datalist      = document.getElementById('deckBuildSearch')
    ,     input         = document.getElementById('deckCardFind')

    addedCardList.innerHTML += `${copies}x ${cardName} \n`
    
    datalist.innerHTML = ''
    input.value = ''
  }

  //autocomplete search for finding cards by name
  //$(document)[0].body.innerHTML += `<img src= "https://img.scryfall.com/cards/small/en/chr/81.jpg">`
  $('#deckCardFind').on('keyup', event => {
    if (event.target.value) {
      const userEntry       = event.target.value.toLowerCase()
      ,     matches         = cardNames.filter(name=> name.toLowerCase().startsWith(userEntry))
      ,     datalist        = document.getElementById('deckBuildSearch')
      ,     firstTenMatches = matches.slice(0,10);

      //only update on change
      if (lastMatch !== firstTenMatches.toString()) {
        datalist.innerHTML = firstTenMatches.map(match=> `<option> ${match} </option>`);
        lastMatch = firstTenMatches.toString();
      };
    };
  });

  //this also triggers just by hitting enter as a mouse event
  $("#addCard").on('click', event => {
    const cardOption = document.getElementById('deckBuildSearch').options[0]
    ,     copies     = document.getElementById('decks_cards_copies').value;

    if (cardOption) {
      const cardName = cardOption.innerText.trim()

      addCardToList(event, cardName, copies);
    }
  })

  $("#new_deck").on('submit', event => {
    event.preventDefault();
  });

  $("#addLand").on('click', event => {
    const landName = document.getElementById('decks_cards_land_name').value
    ,     copies   = document.getElementById('decks_cards_land_copies').value;

    addCardToList(event, landName, copies)
  });

  $("#createDeck").on('click', () => {
    formAuthenticityToken.value = railsAuthenticityToken
    const serializedForm = $("#new_deck").serialize()
    
    $.post(`/decks/create`, serializedForm);
  });

});