document.addEventListener("turbolinks:load", function() {
  const cardCountDiv = document.getElementById('card-counter')
  ,     deckHolder   = document.getElementById('deck-holder')
  ,     numCards     = cardCountDiv ? cardCountDiv.innerHTML.trim().match(/\d+$/)[0] : null
  
  function loadTwoCardsAhead(numCards, cardCount) {
    const inverseNumber = numCards - cardCount
    ,     twoCardsAhead = document.getElementById(`deck-card-${inverseNumber - 1}`)

    twoCardsAhead.src = twoCardsAhead.getAttribute('image_placeholder');
  }

  //clicking through cards on deck show/sample hand
  $('.deck-display').on('click', function() {
    let currentCard = this.parentElement.getAttribute('value');

    deckHolder.setAttribute('value', ++currentCard);

    cardCountDiv.innerHTML = (currentCard <= numCards) ? (`Card ${currentCard} of ${numCards}`) : ('<br>');

    //only apply to large, lazy cards, starting at idx 3 (non-lazy loaded), 
    //we load two card images ahead from then on, excluding the second-to-last card)
    if (currentCard > 3 && currentCard < numCards - 1 && this.getAttribute('class').includes('large')) {
      loadTwoCardsAhead(numCards, currentCard)
    }

    this.remove();
  });
  
});