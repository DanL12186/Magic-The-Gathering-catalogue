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
    event.preventDefault();
    
    const serializedForm = $(this).serialize()
    ,     response = $.post(`/cards/filter_search`, serializedForm);
    
    function generateCardsHTML(cards) {
      return cards.map(card=> {
        const cardClass = card.edition === 'Alpha' ? 'card_img alpha' : 'card_img'
        ,     thumbnail = (card.hi_res_img || card.img_url).replace(/large/,'small')

        return( 
          `<div class = 'col-sm-3'>
            <h3 data-edition= ${card.edition.toLowerCase().replace(/ /g,'_')} data-rarity=${card.rarity.toLowerCase()}> 
              ${card.name} <img src="/assets/editions/${card.edition.toLowerCase()}" class= edition_${card.rarity.toLowerCase()} height=5% width=5% >
            </h3>
            
            <div class=card_img_div> <a href="/cards/${card.id}/"> <img src="${thumbnail}" class=${cardClass} style="width:146px; height: 204px;"> </a> </div>            
            
          </div>`
        )
      })
    };

    response.done(cards => {

      if (cards === null) {
        document.getElementById("find_cards").innerHTML = 'Please Select One or More Options'
        return;
      }

      const html = generateCardsHTML(cards);

      document.getElementById("find_cards").innerHTML = html.join('') || "No results found"

      //create buttons to sort newly displayed card results
      document.getElementById("sort_by_name").innerHTML = `<button>Sort By Name</button>`
      document.getElementById("sort_by_id").innerHTML = `<button>Sort By Multiverse ID</button>`
      document.getElementById("sort_by_price").innerHTML = `<button>Sort By Price</button>`


      $("#sort_by_name").on('click', function(event) {
        event.preventDefault();

        const sortedCards = generateCardsHTML(cards.sort((a,b)=> a.name[0].charCodeAt() - b.name[0].charCodeAt()))
        document.getElementById("find_cards").innerHTML = sortedCards.join('');
      });

      $("#sort_by_id").on('click', function(event) {
        event.preventDefault();
        
        const sortedCards = generateCardsHTML(cards.sort((a,b)=> a.multiverse_id - b.multiverse_id))
        document.getElementById("find_cards").innerHTML = sortedCards.join('');
      });

      $("#sort_by_price").on('click', function(event) {
        event.preventDefault();

        const sortedCards = generateCardsHTML(cards.sort((a,b)=> {
          const [priceA, priceB] = [a, b].map(card=> parseFloat(card.price[1].match(/\d+\,*\d*\.*\d*/) || []))
          return priceB - priceA;
        }));

        document.getElementById("find_cards").innerHTML = sortedCards.join('');
      });
    });
  });

});