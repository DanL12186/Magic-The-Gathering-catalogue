$(document).on("turbolinks:load", function() {

  //clicking hrough cards on deck show page
  $('.deck-display').on('click', function() {
    let   cardCount = this.parentElement.getAttribute('value');
    const currentCardNumber = $("#card-counter")
    ,     numCards = parseInt(currentCardNumber.html().trim().match(/\d+$/)[0]);

    this.parentElement.setAttribute('value', ++cardCount)
    
    currentCardNumber.html(cardCount <= numCards ? `Card ${cardCount} of ${numCards}` : '<br>')

    this.remove();
  });

  //pie chart for displaying deck card-types breakdown on deck overview page
  function pieChartLoader() {
    const jsonData = $("#pieChartContainer").data('json'),
          [ labels, frequencies ] = [ Object.keys(jsonData).map(str=> str.replace('_', ' ')), Object.values(jsonData) ],
          totalCards = frequencies.reduce((a,b)=> a+b),
          dataPoints = [];

    for (let i = 0; i < labels.length; i++) {
      if (['creatures', 'lands', 'spells', 'artifacts'].includes(labels[i])) {
        const percent = Math.round(100 * frequencies[i]/totalCards),
              label   = labels[i].replace(labels[i][0], labels[i][0].toUpperCase());

        dataPoints.push( { label: label, y: frequencies[i], legendText: `${label}: ${percent}%` } )
      }
    }
    
    const options = {
      backgroundColor: "silver",
      title: {
        fontFamily: "MagicMedieval",
        text: "Deck Breakdown",
      },
        animationEnabled: true,
        data: [
          {
            type: "doughnut",
            dataPoints: dataPoints,
            showInLegend: true
          }
        ]
      };
    $("#pieChartContainer").CanvasJSChart(options);
  };

  if (document.getElementById("pieChartContainer")) {
    $("#pieChartContainer").ready(pieChartLoader);
    $("#pieChartContainer").on('turbolinks:load', pieChartLoader)
  }

  //popover for card search results page
  $(function () {
    $('[data-toggle="popover"]').popover({
      html: true,
      boundary: 'scrollParent',
      trigger: 'hover',
      delay: { "show": 200, "hide": 150 },
      content: function() { 
        return `<img src="${this.getAttribute('data-url')}" >`
      }
    })
  })

  //popover remains after hitting back button without this
  $("a.popover-card").on('click', function() {
    $(".popover.fade.right.in").remove()
    //this.parentElement.children[0].remove()
  });
})