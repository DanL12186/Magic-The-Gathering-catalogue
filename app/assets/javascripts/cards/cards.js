$(document).on('turbolinks:load', function() {

  $('.legalities').on('click', function() {
    const legalDiv = document.getElementById('legal')

    if (legalDiv.innerHTML) {
      legalDiv.innerHTML = null;
      legalDiv.style = null;
      return;
    }

    const legalities = JSON.parse(this.getAttribute('data-legalities')),
          legalityHTML = Object.keys(legalities).map(format=> {
            return `<div>${format.replace(format[0], format[0].toUpperCase())}: ${legalities[format] ? 'Legal' : 'Not Legal'}</div>`
          }).join('');
      
    legalDiv.innerHTML = legalityHTML
    legalDiv.style = "background-color: rgba(255,255,255,0.250); max-width: 300px; padding: 20px; border-radius: 5%; transition: 5s;"
  })
  
  const numberWithDelimiter = (strNum, delimeter = ',') => {
    if (strNum === 'N/A') return 'N/A';

    const decimalLength = strNum.includes('.') ? strNum.match(/\.\d+/)[0].length : 0
    ,     strNumArr = strNum.replace(/[^\d\.]/g, '').split('');
    
    const offset = decimalLength + 4;

    for (let i = strNumArr.length - offset; i >= 0; i -= 3) {
      strNumArr[i] += delimeter
    }
    return strNumArr.join('')
  }

  //updates DOM on card show page with new prices if older than 24hrs or prices don't exist.
  if (document.getElementById('card-kingdom')) {
    const stale = $('#prices').data('stale')
    ,     id = $('#prices').data('id');

    if (stale) {
      const response = $.post(`/cards/update_prices?id=${id}`)

      response.done(card=> {
        const oldPrices = document.getElementsByClassName('price')
        //card.price is an array of mtgoldfish, card kingdom, and tcg player prices. Updates DOM if prices changed.
        for (let i = 0; i < 3; i++) {
          const oldPrice = oldPrices[i].innerText.replace(/[\$,]/g,''),
                newPrice = card.price[i];
          
          if (oldPrice !== newPrice) {
            const spanID = $('#prices h4')[i].id,
                  priceSpan = $(`h4#${spanID} span`);

            priceSpan.fadeOut(750).fadeIn(750);

            setTimeout(() => {
              oldPrices[i].innerText = newPrice !== 'N/A' ? '$' + numberWithDelimiter(newPrice) : 'N/A'
            }, 750);
          };
        };
      });
    };
  };

});