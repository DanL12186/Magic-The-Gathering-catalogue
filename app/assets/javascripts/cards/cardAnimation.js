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
    pricesDiv.style = 'transition: 1.2s; margin-left: 57%; margin-top: 3.5%;';
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

  //rotate split-view cards 90 degress counter-clockwise
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

  function fadeCroppedImageInOut(transformed) {
    const croppedDiv = $("#cropped-img-div"),
          croppedImg = document.getElementById('cropped-img'),
          faceCropURL = croppedImg.attributes.original_src.value,
          backCropURL = croppedImg.attributes.reverse_src.value;

    croppedDiv.fadeOut(750).fadeIn(750);

    setTimeout(()=> {
      croppedImg.src = transformed ? backCropURL : faceCropURL
    }, 750)
  }

  let transformed;

  //flip dual-sided cards over and change cropped image with a fade effect to match flipped side
  $('#transform').on('click', function() {
    const cardDiv = document.getElementsByClassName('flip-card-inner')[0];
    
    fadeCroppedImageInOut()

    if (!transformed) {
      cardDiv.style.transform = 'rotateY(180deg)';
      transformed = true;
    } else {
      cardDiv.style.transform = 'rotateY(0deg)';
      transformed = false;
    };
  });
});