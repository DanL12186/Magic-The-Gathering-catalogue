$(document).on('turbolinks:load', function() {
  
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
    });
  });

  //remove popover after leaving page
  $('li.card').on('click', function() {
    this.children[1].remove()
  });

});