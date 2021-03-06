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
//= require bootstrap-sprockets
//= require rails-ujs
//= require turbolinks
//= require lazyload
//= require canvasjs.min
//= require_tree .

document.addEventListener('turbolinks:load', function() {  
  'use strict';
  //lazyload images marked with lazyload: true
  $("img").lazyload({
    effect : "fadeIn"
  });
  
  //popover for card search results and deck show pages
  $('[data-toggle="popover"]').popover({
    html: true,
    boundary: 'scrollParent',
    trigger: 'hover',
    delay: { show: 200, hide: 150 },
  });

  //remove popover from card-search page after leaving
  $('.popover-js').on('click', () => {
    $('.popover.fade').remove()
  });
  
})