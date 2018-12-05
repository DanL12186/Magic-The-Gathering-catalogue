$(document).on('turbolinks:load', function() {
  $(".card_show").on('click', function() {
    const originalSrc = this.getAttribute('original_src')
    ,     hiResImgUrl = this.getAttribute('img_url')

    if (this.src.match(/scryfall/)) {
      this.src = originalSrc;
      this.style.width = "223px";
      this.style.height = "310px";
      
      //ignore unless card has a hi-res image version
    } else if (hiResImgUrl) { 
      this.src = hiResImgUrl; //.replace("large", "normal") for smaller image (488x680 @ ~55-60% file size)
      this.style.width = "502px";
      this.style.height = "700px";
    }
  })

  //popover for card search results page
  $(function () {
    $('[data-toggle="popover"]').popover({
      html: true,
      boundary: 'scrollParent',
      trigger: 'hover',
      delay: { "show": 200, "hide": 150 },
      content: function() { 
        return `<img src="${this.getAttribute('data-url')}" >`
      }
    })
  })

  //popover remains after hitting back button without this
  $("li.card").on('click', function() {
    this.children[1].remove()
  });


  //populate /cards/find_by_properties with found cards
  $("form.find_by_properties").on('submit', function(event) {
    event.preventDefault()
        const serializedForm = $(this).serialize()
        ,     response = $.post(`/cards/filter_search`, serializedForm);
    
    response.done((cards) => {
      const html = cards.map(card=> {
        const cardClass = card.edition === 'Alpha' ? 'card_img alpha' : 'card_img'
        
        return `<div>
          <h1> ${card.name} </h1>
          <h3 data-edition= ${card.edition.toLowerCase().replace(/ /g,'_')} data-rarity=${card.rarity.toLowerCase()}> 
            Edition: <a href="/${card.edition}"> ${card.edition} </a> <img src="/assets/editions/${card.edition.toLowerCase()}" class= edition_${card.rarity.toLowerCase()} height=2% width=2% >
          </h3>
          
      <div class=card_img_div> <a href="/cards/${card.id}/"> <img src="${card.img_url}" class=${cardClass} > </a> </div>            
          
        </div>`
      })

      document.getElementById("find_cards").innerHTML = html.join('');
    })
  })

})