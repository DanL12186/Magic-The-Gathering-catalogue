$(document).on("turbolinks:load", function() {

  $('.deck-display').on('click', function() {
    const currentCardNumber = $("#card-counter")
    ,     numCards = +currentCardNumber.html().trim().match(/\d+$/)[0]
    
    cardCount = this.parentElement.getAttribute('value')
    this.parentElement.setAttribute('value', ++cardCount)
    
    currentCardNumber.html(`Card ${cardCount} of ${numCards}`)
    this.remove()
  });
})