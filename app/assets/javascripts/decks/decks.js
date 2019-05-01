$(document).on("turbolinks:load", function() {

  const sum = arr => arr.reduce((a,b)=> a+b)

  //clicking through cards on deck show page
  $('.deck-display').on('click', function() {
    let   cardCount = this.parentElement.getAttribute('value');
    const currentCardNumber = document.getElementById('card-counter')
    ,     numCards = currentCardNumber.innerHTML.trim().match(/\d+$/)[0];

    document.getElementById('deck-holder').setAttribute('value', ++cardCount);

    currentCardNumber.innerHTML = (cardCount <= numCards) ? (`Card ${cardCount} of ${numCards}`) : ('<br>');

    this.remove();
  });

  //pie chart for displaying deck card-types breakdown on deck overview page
  if (document.getElementById("pieChartContainer")) {
    $("#pieChartContainer").ready(pieChartLoader);
    $("#pieChartContainer").on('turbolinks:load', pieChartLoader)
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

  //popover remains after hitting back button without this
  $("a.popover-card").on('click', function() {
    $(".popover.fade.right.in").remove()
  });
  
});