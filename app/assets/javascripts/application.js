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
//= require jquery
//= require activestorage
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

  //awful, hacky script to get mouseover to change images. temporary. (yes, `edition` is a global variable.)

  $(document).on("turbolinks:load", function() {
    $(".edition_rare").on('mouseenter', function() {
        edition = (this.src.match(/(?<=\/editions\/).*(?=\-)/) || this.src.match(/(?<=\/editions\/).*(?=\.)/))[0]
        const src = `/assets/editions/${edition} rare.png`

        this.src = src
    }).on('mouseleave', function() {
        this.src = `/assets/editions/${edition}.png`
    });

    $(".edition_uncommon").on('mouseenter', function() {
        edition = (this.src.match(/(?<=\/editions\/).*(?=\-)/) || this.src.match(/(?<=\/editions\/).*(?=\.)/))[0]
        const src = `/assets/editions/${edition} uncommon.png`
    
        this.src = src
      }).on('mouseleave', function() {
        this.src = `/assets/editions/${edition}.png`
      });
  })
