document.addEventListener('turbolinks:load', () => {
  const sum = array => array.reduce((a, b) => a + b);

  const pieChartLoader = () => {
    const jsonData = $("#pieChartContainer").data('json'),
      [labels, frequencies] = [Object.keys(jsonData), Object.values(jsonData)],
      totalCards = sum(frequencies),
      dataPoints = [];

    for (let i = 0; i < labels.length; i++) {
      if (['creatures', 'lands', 'spells', 'artifacts'].includes(labels[i])) {
        const percent = Math.round(100 * frequencies[i] / totalCards),
          label = labels[i].replace(labels[i][0], labels[i][0].toUpperCase());

        dataPoints.push({ label: label, y: frequencies[i], legendText: `${label}: ${percent}%` })
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

  const splineChartLoader = () => {
    const jsonData = $("#splineContainer").data('json')

    const options = {
      backgroundColor: "transparent",
      animationEnabled: true,

      title: {
        text: "Mana Curve",
        fontFamily: "MagicMedieval",
        fontColor: "silver",
      },
      axisX: {
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

  //spline chart for displaying a deck's mana curve
  if (document.getElementById('splineContainer')) {
    $("#splineContainer").ready(splineChartLoader);
    $("#splineContainer").on('turbolinks:load', splineChartLoader)
  }

  //pie chart for displaying deck card-types breakdown on deck show page
  if (document.getElementById("pieChartContainer")) {
    $("#pieChartContainer").ready(pieChartLoader);
  }

})