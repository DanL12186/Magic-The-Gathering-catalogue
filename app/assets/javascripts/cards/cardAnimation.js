$(document).on('turbolinks:load', function() {
  let zoomed;

  function zoomOut(element) {
    element.src = element.getAttribute('original_src');
    element.style.width = '223px';
    element.style.height = '310px';
    zoomed = false;
  }

  function zoomIn(element) {
    element.src = element.getAttribute('img_url'); //.replace('large', 'normal') for smaller image (488x680 @ ~55-60% file size)
    element.style.width = '502px';
    element.style.height = '700px';
    zoomed = true;
  }

  //switch transform images to high-res Scryfall image (672x936) from original low-res image (223x310)   
  $("#card_show_img_face, #card_show_img_back").on('click', function() {
    const cardFace    = this.id.includes('face') ? this : document.getElementById('card_show_img_face')
    ,     cardBack    = this.id.includes('back') ? this : document.getElementById('card_show_img_back')

    const pricesDiv     = document.getElementById('prices')
    ,     flipContainer = document.getElementsByClassName('flip-card-inner')[0]

    if (zoomed) {
      pricesDiv.style = 'transition: 2s; float: left';
      flipContainer.style.width = '223px';
      zoomOut(cardFace);
      zoomOut(cardBack);
    } else { 
      pricesDiv.style = 'transition: 1.5s; margin-left: 57%; margin-top: 3.5%;';
      flipContainer.style.width = '502px';
      zoomIn(cardFace)
      zoomIn(cardBack)
    }
  });

  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  $('#card_show_img').on('click', function() {
    zoomed ? zoomOut(this) : zoomIn(this)
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
});