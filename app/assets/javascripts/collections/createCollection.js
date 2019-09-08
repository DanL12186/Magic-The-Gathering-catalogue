document.addEventListener('turbolinks:load', function() {
  let allCardsWithEditions;
  let lastMatch;

  const railsAuthenticityToken = $('head [name=csrf-token]')[0].content;
  const formAuthenticityToken  = $('#new_collection input')[1];

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

  //could bring out AllOrderedEditions from Rails backend to sort cards of the same name by set release order
  //autocomplete search for finding cards by name
  $('#collectionCardFind').on('keyup', event => {
    if (event.target.value) {
      const userEntry  = event.target.value.toLowerCase(),
            matches    = allCardsWithEditions.filter(nameAndEdition=> nameAndEdition[0].toLowerCase().startsWith(userEntry)),
            datalist   = document.getElementById('collectionBuildSearch'),
            topMatches = matches.slice(0,15);

      //equals undefined ( [][0] ) if there are no matches). 
      //Fixes a bug where "enter" makes event.target.value equal to Card Name - Set Name
      const firstCardName = (matches[0] || [])[0]

      //stop at 15 matches, unless a card has > 15 printings (in which case list them all so user can pick their exact card)
      if (topMatches.length === 15 && firstCardName === topMatches[14][0]) {
        for (let i = 15; i < matches.length && matches[i][0] === firstCardName; i++) {
          topMatches.push(matches[i]);
        }
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
});