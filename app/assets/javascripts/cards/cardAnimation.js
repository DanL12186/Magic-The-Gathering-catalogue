//animations on the card show page
$(document).on('turbolinks:load', function() {

  const pricesDiv = document.getElementById('prices')
  let   zoomed;

  //may src.replace('large', 'normal') for smaller 488x680 image @ ~55-60% file size
  function zoomOut(element) {
    pricesDiv.style = 'transition: 2s; float: left';
    element.src = element.getAttribute('original_src');
    element.style.width = '223px';
    element.style.height = '310px';
    zoomed = false;
  }

  function zoomIn(element) {
    pricesDiv.style = 'transition: 1.2s; margin-left: 57.5%; margin-top: 3.5%;';
    element.src = element.getAttribute('img_url');
    element.style.width = '502px';
    element.style.height = '700px';
    zoomed = true;
  }

  //switch transform images to high-res Scryfall image (672x936) from original low-res image (223x310)
  $("#card_show_img_face, #card_show_img_back").on('click', function() {
    const cardFace = this.id.includes('face') ? this : document.getElementById('card_show_img_face')
    ,     cardBack = this.id.includes('back') ? this : document.getElementById('card_show_img_back')

    const flipContainer = document.getElementsByClassName('flip-card-inner')[0]

    if (zoomed) {
      flipContainer.style.width = '223px';
      zoomOut(cardFace);
      zoomOut(cardBack);
    } else { 
      flipContainer.style.width = '502px';
      zoomIn(cardFace)
      zoomIn(cardBack)
    };
  });

  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  $('#card_show_img').on('click', function() {
    zoomed ? zoomOut(this) : zoomIn(this)
  });

  let rotated;

  //rotate split-view cards 90 or -90 degrees
  $("#rotate").on('click', function() {
    const angle = this.getAttribute('data-rotate')
    ,     image = document.getElementById('card_show_img');
    
    if (!rotated) { 
      image.style.marginLeft = '15%';
      image.style.transition = '1.5s';
      image.style.transform = `rotate(${angle}`;
      rotated = true;
    } else {
      rotated = false;
      image.style.marginLeft = '0%';
      image.style.transition = '1.0s';
      image.style.transform = 'rotate(0deg)';
    };
  });

  function fadeCroppedImageInOut() {
    const croppedDiv = $("#cropped-img-div"),
          croppedImg = document.getElementById('cropped-img'),
          faceCropURL = croppedImg.attributes.original_src.value,
          backCropURL = croppedImg.attributes.reverse_src.value;

    croppedDiv.fadeOut(750).fadeIn(750);
   
    setTimeout(()=> {
      croppedImg.src = transformed ? faceCropURL : backCropURL
      transformed = !transformed
    }, 750)
  }

  const flipCardOver = cardDiv => { cardDiv.style.transform = `rotateY(${180-(transformed ? 180 : 0)}deg)` }

  let transformed,
      cardDiv;

  //flip dual-sided cards over and change cropped image with a fade effect to match flipped side
  $('#transform').on('click', function() {
    if (!cardDiv) cardDiv = document.getElementsByClassName('flip-card-inner')[0];

    flipCardOver(cardDiv)
    fadeCroppedImageInOut(cardDiv)
  });
});