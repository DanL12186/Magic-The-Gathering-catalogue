//animations on the card show page
$(document).on('turbolinks:load', function() {
  'use strict';

  const pricesDiv = document.querySelector('.prices-js');
  let   zoomed;

  //accommodates single and double-sided cards for zooming
  //switch to hi res image source and zoom card in (223px => 502px width)
  const zoomIn = (...elements) => {
    elements.forEach(element => element.src = element.getAttribute('hi_res_src'));
    elements.forEach(element => element.classList.add('zoomed'));
    pricesDiv.classList.add('pushed-right');
    zoomed = true;
  }

  const zoomOut = (...elements) => {
    elements.forEach(element => element.classList.remove('zoomed'));
    pricesDiv.classList.remove('pushed-right');
    zoomed = false;
  }

  //switch to high-res Scryfall image (672x936) from original low-res image (223x310) 
  $('#card_show_img').on('click', function() {
    zoomed ? zoomOut(this) : zoomIn(this)
  });

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

  $("#rotate").on('click', function() {
    const angle = this.getAttribute('data-rotate')
    ,     image = document.getElementById('card_show_img');
    
    if (!rotated) { 
      image.style.marginLeft = '15%';
      image.style.transition = '1.5s';
      image.style.transform = `rotate(${angle})`;
    } else {
      image.style.marginLeft = '0%';
      image.style.transition = '1.0s';
      image.style.transform = 'rotate(0deg)';
    };
    rotated = !rotated
  });

  //Fades out cropped face image, fades in cropped back image.
  const fadeSwitchCroppedImage = () => {
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

  const flipCardOver = () => cardDiv.style.transform = `rotateY(${180-(transformed ? 180 : 0)}deg)`

  const temporarilyDisableButton = (button, duration = 850) => {
    button.setAttribute('disabled', true);
    
    setTimeout(()=> {
      button.removeAttribute('disabled');
    }, duration);
  }

  const temporarilyHideOverflow = () => {
    document.body.classList.add('hide-overflow')

    setTimeout(()=> {
      document.body.classList.remove('hide-overflow');
    }, 950);
  }

  const cardNameSpan = $("#name_and_edition");
  let   faceCardName,
        backCardName;

  if (document.getElementById("transform")) {
    faceCardName = cardNameSpan[0].innerText.replace(/\(.+/, '').trim();
    backCardName = this.getElementsByClassName("col-sm-3 flip-card")[0].getAttribute('data-flipname');
  };

  //change flip card name to the face that's currently showing
  const fadeSwitchName = () => {
    const currentFaceName = transformed ? backCardName : faceCardName,
          currentBackName = transformed ? faceCardName : backCardName;

    cardNameSpan.fadeOut(750).fadeIn(750)

    setTimeout(()=> {
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