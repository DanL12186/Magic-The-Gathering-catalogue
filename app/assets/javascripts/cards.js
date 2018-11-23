$(document).on('turbolinks:load', function() {
  $(".card_show").on('click', function() {
    const originalSrc = this.getAttribute('original_src')
    ,     hiResImgUrl = this.getAttribute('img_url')

    if (this.src.match(/scryfall/)) {
      this.src = originalSrc;
      this.style.width = "225px";
      this.style.height = "310px";
      
      //ignore unless card has a hi-res image version
    } else if (hiResImgUrl) { 
      this.src = hiResImgUrl;
      this.style.width = "507px";
      this.style.height = "700px";
    }
  })

  //popover for card search results page
  $(function () {
    $('[data-toggle="popover"]').popover({
      html: true,
      trigger: 'hover',
      delay: { "show": 200, "hide": 150 },
      content: function() { 
        return `<img src = "${this.getAttribute('data-url')}" >`
      }
    })
  })

  //popover remains after hitting back button without this
  $("li.card").on('click', function() {
    this.children[1].remove()
  });
})
