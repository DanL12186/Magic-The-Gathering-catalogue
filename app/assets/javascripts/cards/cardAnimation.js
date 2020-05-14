//animations on the card show page
document.addEventListener('turbolinks:load', function() {
  'use strict';

  const pricesDiv    = document.querySelector('.prices-js');
  const foilOverlays = document.querySelectorAll('.foil-overlay-js');
  const rotateButton = document.querySelector('#rotate');

  let   zoomed;

  const drainBackgroundColor = () => {
    document.body.style.transition = '1.5s';
    document.body.style.backgroundColor = 'rgb(0, 0, 0)';
  }

  const returnBackgroundColor = () => document.body.style.backgroundColor = 'rgb(1, 22, 9)';

  //accommodates single and double-sided cards for zooming
  //switch to high-res image source and zoom card in (223px => 502px width)
  const zoomIn = (...elements) => {
    foilOverlays.forEach(element => element.classList.add('zoomedFoiling'));
    elements.forEach(element => element.src = element.getAttribute('hi_res_src'));
    elements.forEach(element => element.classList.add('zoomed'));
    pricesDiv.classList.add('pushed-right');
    zoomed = true;

    drainBackgroundColor();
  }

  const zoomOut = (...elements) => {
    foilOverlays.forEach(element => element.classList.remove('zoomedFoiling'))
    elements.forEach(element => element.classList.remove('zoomed'));
    pricesDiv.classList.remove('pushed-right');
    zoomed = false;

    returnBackgroundColor();
  }

  const cardShowImage = document.getElementById('card_show_img')
  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  if (cardShowImage) {
    cardShowImage.addEventListener('click', function() {
      zoomed ? zoomOut(this) : zoomIn(this)
    });
  };

  //switch transform face/back images to high-res Scryfall image (672x936) from original low-res images (223x310)
  $("#card_show_img_face, #card_show_img_back").on('click', function() {
    const cardFace      = this.id.includes('face') ? this : document.getElementById('card_show_img_face');
    const cardBack      = this.id.includes('back') ? this : document.getElementById('card_show_img_back');
    const flipContainer = document.querySelector('.flip-card-inner');

    if (zoomed) {
      flipContainer.style.width = '223px';
      zoomOut(cardFace, cardBack);
    } else { 
      flipContainer.style.width = '502px';
      zoomIn(cardFace, cardBack);
    };
  });

  //rotate split-view cards 90 or -90 degrees
  let rotated;

  if (rotateButton) {
    rotateButton.addEventListener('click', event => {
      const foilOverlay = document.querySelector('.foil-overlay'),
            image       = document.getElementById('card_show_img'),
            angle       = event.target.getAttribute('data-rotate'),
            elements    = [image, foilOverlay];
      
      elements.forEach(element => {
        element.style.transform  = rotated ? `rotate(0deg)` : `rotate(${angle})`;
        element.style.marginLeft = rotated ?    '0%'        :       '15%';
        element.style.transition = rotated ?   '1.0s'       :       '1.5s';
      })
      rotated = !rotated;
    });
  }

  //Fades out cropped face image, fades in cropped back image.
  const fadeSwitchCroppedImage = () => {
    const croppedDiv  = $("#cropped-img-div"),
          croppedImg  = document.getElementById('cropped-img'),
          faceCropURL = croppedImg.attributes.original_src.value,
          backCropURL = croppedImg.attributes.reverse_src.value;

    croppedDiv.fadeOut(750).fadeIn(750);
    
    setTimeout(() => {
      croppedImg.src = transformed ? faceCropURL : backCropURL
      transformed = !transformed
    }, 750)
  };

  const flipCardOver = () => cardDiv.style.transform = `rotateY(${180-(transformed ? 180 : 0)}deg)`

  const temporarilyDisableButton = (button, duration = 850) => {
    button.setAttribute('disabled', true);
    
    setTimeout(() => {
      button.removeAttribute('disabled');
    }, duration);
  };

  const temporarilyHideOverflow = () => {
    document.body.classList.add('hide-overflow')

    setTimeout(()=> {
      document.body.classList.remove('hide-overflow');
    }, 950);
  };

  const cardNameSpan = $("#name_and_edition")
  let   faceCardName
  let   backCardName

  if (document.getElementById("transform")) {
    faceCardName = cardNameSpan[0].innerText.replace(/\(.+/, '').trim()
    backCardName = this.querySelector(".flip-card-outer").getAttribute('data-flipname')
  };

  //change flip card name to the face that's currently showing
  const fadeSwitchName = () => {
    const currentFaceName = transformed ? backCardName : faceCardName
    const currentBackName = transformed ? faceCardName : backCardName

    cardNameSpan.fadeOut(750).fadeIn(750)

    setTimeout(() => {
      cardNameSpan[0].innerHTML = cardNameSpan[0].innerHTML.replace(currentFaceName, currentBackName)
    }, 750);
  };

  //flip dual-sided cards over and change name and cropped image with a fade effect
  let transformed,
      cardDiv;

  $('#transform').on('click', function() {
    if (cardDiv === undefined) {
      cardDiv = document.getElementsByClassName('flip-card-inner')[0];
    }

    temporarilyDisableButton(this, 950);

    flipCardOver();

    //hide overflow if user does not have a vertical scroll bar (card can rotate partway off screen and create one)
    if (document.body.clientHeight <= window.innerHeight) {
      temporarilyHideOverflow();
    }
    
    fadeSwitchName();
    fadeSwitchCroppedImage();
  });

});