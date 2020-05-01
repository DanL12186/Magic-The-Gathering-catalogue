document.addEventListener('turbolinks:load', function() {
  const railsAuthenticityToken = $('head [name=csrf-token]')[0].content

  const foilOverlays = document.querySelectorAll('.foil-overlay-js');
  let showFoil;
  
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

  //change links to point to foil versios of cards, display foil overlay
  const updatePageToReflectFoil = showFoil => {
    const eBayLink = document.querySelector('#ebayLink a');
    const [mtgLink, ckLink, _] = document.querySelectorAll('#prices h4 a');

    if (showFoil) {
      eBayLink.innerText = eBayLink.innerText.replace('Find', 'Find foil')
      eBayLink.href += '+foil'

      foilOverlays.forEach(element => element.classList.remove('hidden'));

      mtgLink.href = mtgLink.href.replace(/\/price\/[A-z+]+/, m => m + ':Foil')
      ckLink.href  = ckLink.href.replace(/[a-z-]+$/, m => m + '-foil')
    } else {
      eBayLink.innerText = eBayLink.innerText.replace('foil', '')
      eBayLink.href      = eBayLink.href.replace('+foil', '')

      foilOverlays.forEach(element => element.classList.add('hidden'));

      mtgLink.href = mtgLink.href.replace(':Foil', '')
      ckLink.href  = ckLink.href.replace('-foil', '')
    }
  }

  //allow for toggling between foil and nonfoil prices, if they exist
  const toggleFoilButton = document.getElementById('toggle-foil-js');
  let nonfoilPrices = [...document.getElementsByClassName('price')].map(span => span.innerText.replace(/[\$,]/g,''));

  if (toggleFoilButton) {
    const foilPrices = JSON.parse(document.getElementById('prices').getAttribute('data-foil-prices'))
    const priceDivs  = [...document.getElementsByClassName('price')]

    toggleFoilButton.addEventListener('click', () => {
      priceDivs.forEach((priceDiv, i) => {
        const price = showFoil ? nonfoilPrices[i] : foilPrices[i]

        priceDiv.innerText = /\d+/.test(price) ? '$' + numberWithDelimiter(price) : 'N/A'
      })

      showFoil = !showFoil

      toggleFoilButton.innerText = showFoil ? 'View nonfoil version' : 'View foil version'
      updatePageToReflectFoil(showFoil)
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

          if (!showFoil && newPrice && oldPrice !== newPrice) {
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