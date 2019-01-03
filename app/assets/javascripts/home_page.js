// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('turbolinks:load', function() {
  //lazyload images marked with lazyload: true
  $("img").lazyload();
  
	//change edition symbol color to silver or gold if card is uncommon or rare
  $(".edition_rare, .edition_uncommon, .edition_mythic").on('mouseenter', function() {
    const edition = this.parentElement.getAttribute('data-edition').replace(/_/g, ' ')
    ,     rarity  = this.parentElement.getAttribute('data-rarity');
    this.src = `/assets/editions/${edition} ${rarity}`;

  }).on('mouseleave', function() {
    const edition = this.parentElement.getAttribute('data-edition').replace(/_/g, ' ');
    this.src = `/assets/editions/${edition}`;
  });

})