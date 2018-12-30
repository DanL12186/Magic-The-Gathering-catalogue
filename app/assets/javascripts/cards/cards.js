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

  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  $(".card_show").on('click', function() {
    const originalSrc = this.getAttribute('original_src')
    ,     hiResImgUrl = this.getAttribute('img_url')

    if (this.src.includes('scryfall')) {
      this.src = originalSrc;
      this.style.width = "223px";
      this.style.height = "310px";
      //ignore unless card has a hi-res image version
    } else if (hiResImgUrl) { 
      this.src = hiResImgUrl; //.replace("large", "normal") for smaller image (488x680 @ ~55-60% file size)
      this.style.width = "502px";
      this.style.height = "700px";
    }
  });

  //updates DOM on card show page with new prices if older than 24hrs or prices don't exist.
  if (document.getElementById('card-kingdom')) {
    const stale = $(".price").data('stale')
    ,     id = $('.price')[0].id;

    if (stale) {
      const response = $.post(`/cards/update_prices?id=${id}`)
      
      response.done(card=> {
        //card.price is an array of mtgoldfish, card kingdom, and tcg player prices. Updates DOM if price has changed.
        for (let i = 0; i < 3; i++) {
          const oldPrice = $("h4 span")[i].innerText.replace(/[\$,]/g,''),
                newPrice = card.price[i];

          if (oldPrice !== newPrice) {
            const spanID = $("h4")[i+1].id,
                  price  = card.price[i],
                  selector = `h4#${spanID} span`;

            $(selector).fadeOut(750).fadeIn(750)

            setTimeout(() => {
              $("h4 span")[i].innerText = newPrice !== 'N/A' ? '$' + numberWithDelimiter(price) : 'N/A'
            }, 750)
          };
        }
      })
    }
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

  //remove popover after leaving page
  $("li.card").on('click', function() {
    this.children[1].remove()
  });

});