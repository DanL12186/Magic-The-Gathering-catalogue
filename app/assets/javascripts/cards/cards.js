document.addEventListener('turbolinks:load', function() {
  const railsAuthenticityToken = $('head [name=csrf-token]')[0].content

  let priceToggled;
  
  const numberWithDelimiter = (strNum, delimeter = ',') => {
    if (strNum === 'N/A') return 'N/A'

    const decimalLength = strNum.includes('.') ? strNum.match(/\.\d+/)[0].length : 0;
    const strNumArr     = strNum.replace(/[^\d\.]/g, '').split('');
    const offset        = decimalLength + 4;

    for (let i = strNumArr.length - offset; i >= 0; i -= 3) {
      strNumArr[i] += delimeter
    }
    return strNumArr.join('')
  }

  //allow for toggling between foil and nonfoil prices, if they exist
  const toggleFoilPriceButton = document.getElementById('toggle-foil-prices');
  let nonfoilPrices = [...document.getElementsByClassName('price')].map(span => span.innerText.replace(/[\$,]/g,''));

  if (toggleFoilPriceButton) {
    const foilPrices = JSON.parse(document.getElementById('prices').getAttribute('data-foil-prices'))
    const priceDivs  = [...document.getElementsByClassName('price')]

    toggleFoilPriceButton.addEventListener('click', () => {
      priceDivs.forEach((priceDiv, i) => {
        const price = priceToggled ? nonfoilPrices[i] : foilPrices[i]

        priceDiv.innerText = /\d+/.test(price) ? '$' + numberWithDelimiter(price) : 'N/A'
      })

      priceToggled = !priceToggled

      toggleFoilPriceButton.innerText = priceToggled ? 'View nonfoil prices' : 'View foil prices'
    })
  };

  //updates DOM on card show page with new prices if older than 24hrs or prices don't exist.
  if (document.getElementById('prices')) {
    const stale = $('#prices').data('stale')
    const id    = $('#prices').data('id')

    if (stale) {
      const response = $.post(`/cards/update_prices`, { id: id, authenticity_token: railsAuthenticityToken } )
    
      response.done(cardPrices => {
        const oldPrices = document.getElementsByClassName('price')

        //save updated non-foil prices for switching
        nonfoilPrices = cardPrices

        //Updates DOM if prices changed.
        for (let i = 0; i < 3; i++) {
          const oldPrice = oldPrices[i].innerText.replace(/[\$,]/g,'')
          const newPrice = cardPrices[i]

          if (!priceToggled && newPrice && oldPrice !== newPrice) {
            const spanID = document.querySelectorAll('#prices h4')[i].id;
            const priceSpan = document.querySelector(`h4#${spanID} span`);

            $(priceSpan).fadeOut(750).fadeIn(750);

            setTimeout(() => {
              oldPrices[i].innerText = newPrice !== 'N/A' ? '$' + numberWithDelimiter(newPrice) : 'N/A'
            }, 750);
          };
        };
      });
    };
  };

});