document.addEventListener('turbolinks:load', function() {

  //change edition symbol color to silver or gold if card is uncommon or rare
  $(".rare, .uncommon, .mythic").on('mouseenter', function() {
    const edition = this.parentElement.getAttribute('data-edition')
    const rarity  = this.getAttribute('class').match(/rare|uncommon|mythic/)
    if (!edition) return
    this.src = `/assets/editions/${edition} ${rarity}`;
  }).on('mouseleave', function() {
    const edition = this.parentElement.getAttribute('data-edition');
    if (!edition) return
    this.src = `/assets/editions/${edition}`;
  });  

})