document.addEventListener('turbolinks:load', function() {
  let allCardsWithEditions;
  let lastMatch;

  const railsAuthenticityToken = $('head [name=csrf-token]')[0].content;
  const formAuthenticityToken  = $("#new_collection input")[1];

  //clear autocomplete form on refresh
  if (this.getElementById('collectionCardFind')) {
    this.getElementById('collectionCardFind').value = ''
  }

  $('#collectionCardFind').on('focus', () => {
    if (!allCardsWithEditions) {
      const response = $.get('/cards/card_names_with_editions');

      response.done(names => {
        allCardsWithEditions = names.sort((a,b) => a[0].localeCompare(b[0]) || a[1].localeCompare(b[1]));
      })
    }
  })

  const addCardToList = (event, cardName, cardEdition, copies) => {
    event.preventDefault();

    const addedCardList = document.getElementById('collections_cards_list'),
          datalist      = document.getElementById('collectionBuildSearch'),
          input         = document.getElementById('collectionCardFind')

    addedCardList.innerHTML += `${copies}x ${cardName} - ${cardEdition} \n`
    
    datalist.innerHTML = ''
    input.value = ''
  }

  //autocomplete search for finding cards by name
  //$(document)[0].body.innerHTML += `<img src= "https://img.scryfall.com/cards/small/en/chr/81.jpg">`
  $('#collectionCardFind').on('keyup', event => {
    if (event.target.value) {
      const userEntry           = event.target.value.toLowerCase(),
            matches             = allCardsWithEditions.filter(nameAndEdition=> nameAndEdition[0].toLowerCase().startsWith(userEntry)),
            datalist            = document.getElementById('collectionBuildSearch'),
            firstFifteenMatches = matches.slice(0,15);

      //only update on change
      if (lastMatch !== firstFifteenMatches.toString()) {
        datalist.innerHTML = firstFifteenMatches.map(nameAndEdition => {
          const name = nameAndEdition[0];
          const edition = nameAndEdition[1];

          return `<option> ${name} - ${edition} </option>`;
        })
        lastMatch = firstFifteenMatches.toString();
      };
    };
  });

  //Grabs either the option from the datalist the user selected (selectedOption)...
  //..or whatever's in the text box if they hit enter without explicitly selecting one (unselectedOption)
  $("#addCollectionCard").on('click', event => {
    const copies           = document.getElementById('collections_cards_copies').value,
          unselectedOption = document.getElementById('collectionBuildSearch').options[0],
          selectedOption   = document.getElementById('collectionCardFind').value,
          card             = unselectedOption ? unselectedOption.innerText : selectedOption,
          cardName         = card.trim().split(' - ')[0],
          cardEdition      = card.trim().split(' - ')[1];

    addCardToList(event, cardName, cardEdition, copies);
  })

  $("#new_collection").on('submit', event => {
    event.preventDefault();
  });

  $("#createCollection").on('click', () => {
    formAuthenticityToken.value = railsAuthenticityToken
    const serializedForm = $("#new_collection").serialize()

    $.post(`/collections/create`, serializedForm);
  });
})
