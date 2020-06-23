$(document).on("turbolinks:load", function() {
  const sum = array => array.reduce((a,b)=> a+b);

  const cardCountDiv = document.getElementById('card-counter')
  ,     deckHolder   = document.getElementById('deck-holder')
  ,     numCards     = cardCountDiv ? cardCountDiv.innerHTML.trim().match(/\d+$/)[0] : null
  
  function loadTwoCardsAhead(numCards, cardCount) {
    const inverseNumber = numCards - cardCount
    ,     twoCardsAhead = document.getElementById(`deck-card-${inverseNumber - 1}`)

    twoCardsAhead.src = twoCardsAhead.getAttribute('image_placeholder');
  }

  //clicking through cards on deck show/sample hand
  $('.deck-display').on('click', function() {
    let currentCard = this.parentElement.getAttribute('value');

    deckHolder.setAttribute('value', ++currentCard);

    cardCountDiv.innerHTML = (currentCard <= numCards) ? (`Card ${currentCard} of ${numCards}`) : ('<br>');

    //only apply to large, lazy cards, starting at idx 3 (non-lazy loaded), 
    //we load two card images ahead from then on, excluding the second-to-last card)
    if (currentCard > 3 && currentCard < numCards - 1 && this.getAttribute('class').includes('large')) {
      loadTwoCardsAhead(numCards, currentCard)
    }

    this.remove();
  });

  //pie chart for displaying deck card-types breakdown on deck show page
  if (document.getElementById("pieChartContainer")) {
    $("#pieChartContainer").ready(pieChartLoader);
  }

  function pieChartLoader() {
    const jsonData = $("#pieChartContainer").data('json'),
          [ labels, frequencies ] = [ Object.keys(jsonData), Object.values(jsonData) ],
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
  
});