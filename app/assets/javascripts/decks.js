$(document).on("turbolinks:load", function() {
  //clear autocomplete form on refresh
  if (this.getElementById('deckCardFind')) {
    this.getElementById('deckCardFind').value = ''
  }

  const sum = arr => arr.reduce((a,b)=> a+b)

  //clicking through cards on deck show page
  $('.deck-display').on('click', function() {
    let   cardCount = this.parentElement.getAttribute('value');
    const currentCardNumber = document.getElementById('card-counter')
    ,     numCards = parseInt(currentCardNumber.innerHTML.trim().match(/\d+$/)[0]);

    document.getElementById('deck-holder').setAttribute('value', ++cardCount);

    currentCardNumber.innerHTML = (cardCount <= numCards) ? (`Card ${cardCount} of ${numCards}`) : ('<br>');

    this.remove();
  });

  //pie chart for displaying deck card-types breakdown on deck overview page
  if (document.getElementById("pieChartContainer")) { //load only on correct page
    $("#pieChartContainer").ready(pieChartLoader);
    $("#pieChartContainer").on('turbolinks:load', pieChartLoader)
  }

  function pieChartLoader() {
    const jsonData = $("#pieChartContainer").data('json'),
          [ labels, frequencies ] = [ Object.keys(jsonData).map(str=> str.replace('_', ' ')), Object.values(jsonData) ],
          totalCards = sum(frequencies),
          dataPoints = [];

    for (let i = 0; i < labels.length; i++) {
      if (['creatures', 'lands', 'spells', 'artifacts'].includes(labels[i])) {
        const percent = Math.round(100 * frequencies[i]/totalCards),
              label   = labels[i].replace(labels[i][0], labels[i][0].toUpperCase());

        dataPoints.push( { label: label, y: frequencies[i], legendText: `${label}: ${percent}%` } )
      }
    }

    const options = {
      backgroundColor: "transparent",
      title: {
        fontFamily: "MagicMedieval",
        text: "Deck Breakdown",
        fontColor: "silver",  
      },
      animationEnabled: true,
      legend: { 
        fontColor: 'silver' 
      },
      data: [
        {
          type: "doughnut",
          dataPoints: dataPoints,
          showInLegend: true,
          indexLabelFontColor: 'silver'
        }
      ]
    };

    new CanvasJS.Chart("pieChartContainer", options).render();
  };
  

  //spline chart for displaying a deck's mana curve
  if (document.getElementById('splineContainer')) { //prevent chart from attempting to render on wrong page
    $("#splineContainer").ready(splineLoader);
    $("#splineContainer").on('turbolinks:load', splineLoader)
  }

  function splineLoader() {
    const jsonData = $("#splineContainer").data('json')

    const options = {
      backgroundColor: "transparent",
      animationEnabled: true,
      
      title: {
        text: "Mana Curve",
        fontFamily: "MagicMedieval",
        fontColor: "silver",
      },
      axisX:  { 
        title: "Number of Cards",
        titleFontColor: 'silver',
        labelFontColor: 'silver',
        axisThickness: 20,
        lineColor: 'silver'
      },
      axisY: {
        labelFontColor: 'silver',
        lineColor: 'silver'
      },
      data: [
        {
          type: "spline", //line, column, pie, etc
          color: "#096e30",
          lineThickness: 5,
          markerColor: 'silver',
          dataPoints: jsonData
        }
      ]
    };
    
    new CanvasJS.Chart("splineContainer", options).render();
  };

  //popover remains after hitting back button without this
  $("a.popover-card").on('click', function() {
    $(".popover.fade.right.in").remove()
  });

//=======================================

  let cardNames,
      lastMatch;

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
  //console.log(event.key) gives me the current key. On enter, I can hijack the form. 
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
    console.log('addCard was clicked')
    const cardOption = document.getElementById('deckBuildSearch').options[0]
    ,     copies     = document.getElementById('decks_cards_copies').value;

    if (cardOption) {
      const cardName = cardOption.innerText.trim()

      addCardToList(event, cardName, copies)
    }
  })

  $("#new_deck").on('submit', event => {
    event.preventDefault()
    console.log("deckCardSearch form submitted and stopped")
  })

  $("#addLand").on('click', event => {
    const landName = document.getElementById('decks_cards_land_name').value
    ,     copies   = document.getElementById('decks_cards_land_copies').value;

    addCardToList(event, landName, copies)
  })

  $("#createDeck").on('click', () => {
    const serializedForm = $("#new_deck").serialize()
    
    $.post(`/decks/create`, serializedForm);
  })


//==============================================







});