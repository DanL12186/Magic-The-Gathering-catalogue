document.addEventListener('turbolinks:load', function() {
  let allCardsWithEditions;
  let lastMatch;

  const railsAuthToken = $('head [name=csrf-token]')[0].content;
  const formAuthToken  = $('#new_collection input')[1];

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
  });

  const addCardToList = (event, cardName, cardEdition, copies) => {
    event.preventDefault();

    const addedCardList = document.getElementById('collections_cards_list'),
          datalist      = document.getElementById('collectionBuildSearch'),
          input         = document.getElementById('collectionCardFind');

    addedCardList.innerHTML += `${copies}x ${cardName} - ${cardEdition} \n`
    
    datalist.innerHTML = ''
    input.value = ''
  }

  const addRemainingPrintings = (matches, firstCardName, topMatches) => {
    for (let i = 15; i < matches.length && matches[i][0] === firstCardName; i++) {
      topMatches.push(matches[i]);
    }
  }

  //bind user input for name of collection or deck to DOM
  const collectionNameEntry = document.getElementById('collection_name') || document.getElementById('deck_name')
  
  if (collectionNameEntry) {
    const collectionTitle = document.getElementById('collection-page-title')

    collectionNameEntry.addEventListener('keyup', event => {
      collectionTitle.innerHTML = event.target.value;
    })
  }

  //could bring out AllOrderedEditions from Rails backend to sort cards of the same name by set release order
  //autocomplete search for finding cards by name
  $('#collectionCardFind').on('keyup', event => {
    if (event.target.value) {
      const userEntry  = event.target.value.toLowerCase(),
            matches    = allCardsWithEditions.filter(nameAndEdition => nameAndEdition[0].toLowerCase().startsWith(userEntry)),
            datalist   = document.getElementById('collectionBuildSearch'),
            topMatches = matches.slice(0,15);

      //equals undefined ( [][0] ) if there are no matches). 
      //Fixes a bug where "enter" makes event.target.value equal to Card Name - Set Name
      const firstCardName = (matches[0] || [])[0]

      //add the rest of a card's printings if it has > 15 printings so the user may choose their exact card
      if (topMatches.length === 15 && firstCardName === topMatches[14][0]) {
        addRemainingPrintings(matches, firstCardName, topMatches)
      }

      //only update on change
      if (lastMatch !== topMatches.toString()) {
        datalist.innerHTML = topMatches.map(nameAndEdition => {
          const [ name, edition ] = nameAndEdition;
          
          return `<option> ${name} - ${edition} </option>`;
        })
        lastMatch = topMatches.toString();
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

    if (cardName) {
      addCardToList(event, cardName, cardEdition, copies);
    }
  })

  $("#new_collection").on('submit', event => {
    event.preventDefault();
  });

  $("#createCollection").on('click', () => {
    formAuthToken.value = railsAuthToken
    const serializedForm = $("#new_collection").serialize()

    $.post(`/collections/create`, serializedForm);
  });
});