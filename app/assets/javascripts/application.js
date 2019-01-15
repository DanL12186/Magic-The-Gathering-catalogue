// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require jquery3
//= require bootstrap-sprockets
//= require turbolinks
//= require lazyload
//= require_tree .

$(document).on('turbolinks:load', function() {
  //lazyload images marked with lazyload: true
  $("img").lazyload();
  
  //change edition symbol color to silver or gold if card is uncommon or rare
  $(".rare, .uncommon, .mythic").on('mouseenter', function() {
    const edition = this.parentElement.getAttribute('data-edition').replace(/_/g, ' ')
    ,     rarity  = this.getAttribute('class');
    this.src = `/assets/editions/${edition} ${rarity}`;
  }).on('mouseleave', function() {
    const edition = this.parentElement.getAttribute('data-edition').replace(/_/g, ' ');
    this.src = `/assets/editions/${edition}`;
  });  

  //popover for card search results and deck overview pages
  $(function () {
    $('[data-toggle="popover"]').popover({
      html: true,
      boundary: 'scrollParent',
      trigger: 'hover',
      delay: { "show": 200, "hide": 150 },
      content: function() { 
        return `<img src="${this.getAttribute('data-url')}" >`
      }
    });
  });

  //remove popover from card-search page after leaving
  $('li.card').on('click', function() {
    $('.popover.fade').remove()
  });
  
})