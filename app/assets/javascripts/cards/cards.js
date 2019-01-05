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

  let zoomed;

  //switch transform images to high-res Scryfall image (672x936) from original low-res image (223x310)   
  $("#card_show_img_face, #card_show_img_back").on('click', function() {
    const cardFace    = this.id.includes('face') ? this : document.getElementById('card_show_img_face')
    ,     cardBack    = this.id.includes('back') ? this : document.getElementById('card_show_img_back')
    ,     originalSrc = cardFace.getAttribute('original_src')
    ,     hiResImgUrl = cardFace.getAttribute('img_url')
    ,     originalTwinSrc = cardBack.getAttribute('original_src')
    ,     hiResImgUrlTwin = cardBack.getAttribute('img_url');

    const pricesDiv     = document.getElementById('prices')
    ,     flipContainer = document.getElementsByClassName('flip-card-inner')[0]

    if (zoomed) {
      pricesDiv.style = 'transition: 2s; float: left';
      flipContainer.style.width = '223px';
      cardFace.src = originalSrc;
      cardBack.src = originalTwinSrc;
      [cardFace, cardBack].forEach(face=> [face.style.width, face.style.height] = ['223px', '310px']);
      zoomed = false;
    } else { 
      pricesDiv.style = 'transition: 1.5s; margin-left: 57%; margin-top: 3.5%;'
      flipContainer.style.width = '502px';
      cardFace.src = hiResImgUrl;
      cardBack.src = hiResImgUrlTwin;
      [cardFace, cardBack].forEach(face=> [face.style.width, face.style.height] = ['502px', '700px']);
      zoomed = true
    }
  });

  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  $('#card_show_img').on('click', function() {
    const originalSrc = this.getAttribute('original_src')
    ,     hiResImgUrl = this.getAttribute('img_url')

    if (zoomed) {
      this.src = originalSrc;
      this.style.width = '223px';
      this.style.height = '310px';
      zoomed = false
    } else { 
      this.src = hiResImgUrl; //.replace('large', 'normal') for smaller image (488x680 @ ~55-60% file size)
      this.style.width = '502px';
      this.style.height = '700px';
      zoomed = true
    }
  });

  //rotate split-view cards 90 degress counter-clockwise
  let rotated;

  $("#rotate").on('click', function() {
    const direction = this.getAttribute('data-rotate') === 'cw' ? '90deg' : '-90deg'
    ,     image     = document.getElementById('card_show_img');
    
    if (!rotated) {  
      image.style.transition = '1.5s';
      image.style.transform = `rotate(${direction}`;
      rotated = true;
    } else {
      rotated = false;
      image.style.transition = '1.0s';
      image.style.transform = 'rotate(0deg)';
    };
  });
  
  //flip dual-sided cards over
  let transformed; 

  $('#transform').on('click', function() {
    const div = document.getElementsByClassName('flip-card-inner')[0]
    if (!transformed) {
      div.style.transform = 'rotateY(180deg)';
      transformed = true;
    } else {
      transformed = false;
      div.style.transform = 'rotateY(0deg)';
    };
  });

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
  $('li.card').on('click', function() {
    this.children[1].remove()
  });

});