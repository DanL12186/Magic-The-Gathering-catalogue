$(document).on('turbolinks:load', function() {
  //populate /cards/find_by_properties with found cards
  $("form.find_by_properties").on('submit', function(event) {
    event.stopPropagation();
    event.preventDefault();

    //reset page #s
    document.getElementById("find-by-pagination").innerHTML = null;
    document.getElementById("pagination-pg-num").style = "display: none;"
    
    function generateCardsHTML(cards, currentPage) {
      const slice = currentPage * 60
      return cards.map(card=> {
        const cardClass = card.edition === 'Alpha' ? 'thumb alpha' : 'thumb'
        ,     thumbnail = (card.hi_res_img || card.img_url).replace(/large/,'small')
        ,     edition   = card.edition.toLowerCase()
        ,     rarity    = card.rarity.toLowerCase();
        
        return( 
          `<div class= col-sm-3>
            <h3 data-edition= ${edition.replace(/ /g, '_')} data-rarity=${rarity} style="font-family: MagicMedieval; font-size:1.5vw;"> 
              ${card.name} <img src="/assets/editions/${edition}" class=edition_${rarity} width=5% >
            </h3>
            
            <div class=card_img_div> 
              <a href="/cards/${card.id}/"> <img src="${thumbnail}" class="${cardClass}" style="width: 146px; height: 204px;"> </a> 
            </div>
            
          </div>`
        )
        
      }).slice(slice, slice + 60).join('')
    };

    function displayResults(results) {
      document.getElementById("find_cards").innerHTML = results;
    }

    function generateAndDisplayHTML(sortedResult, currentPage = 0) {
      const sortedHTML = generateCardsHTML(sortedResult, currentPage)
      displayResults(sortedHTML, currentPage)
    }

    const serializedForm = $(this).serialize()
    ,     response = $.post(`/cards/find_by_properties`, serializedForm);
    
    response.done(cardsAndFormOptions => {
      const [cards, options] = cardsAndFormOptions

      if (cards === null) {
        $("a.btn-sm").empty()
        displayResults('Please Select One or More Options')
        return;
      } else if (cards.length === 0) {
        $("a.btn-sm").empty()
        displayResults("No results found")
        return;
      }

      const numPages = Math.ceil(cards.length / 60)
      ,     html = generateCardsHTML(cards, 0);

      if (numPages > 1) {
        document.getElementById("pagination-pg-num").style = "display: block"
        document.getElementById("find-by-pagination").innerHTML += `<span> </span>`

        for (let i = 0; i < numPages; i++) {
          $("div#find-by-pagination")[0].innerHTML += `<button class="btn-group-sm jslink"> ${i} </button>`;
        }
      };

      displayResults(html);

      //create buttons to sort newly displayed card results
      //could make sort buttons into a dropdown instead for space reasons
      document.getElementById("sort_by_name").innerHTML = `<button>Sort By Name</button>`
      document.getElementById("sort_by_id").innerHTML = `<button>Sort By Multiverse ID</button>`
      document.getElementById("sort_by_price").innerHTML = `<button>Sort By Price</button>`

      //remove/don't display buttons to sort by properties that are already filtered for
      if (options.color === undefined) {
        document.getElementById("sort_by_color").innerHTML = `<button>Sort By Color</button>`
      } else {
        $("#sort_by_color").empty();
      }

      if (options.card_type === undefined) {
        document.getElementById("sort_by_type").innerHTML = `<button>Sort By Type</button>`
      } else {
        $("#sort_by_type").empty();
      }

      $(".jslink").on('click', function(event) {
        event.preventDefault();

        generateAndDisplayHTML(cards, parseInt(this.innerHTML))

        createEventListener();
        return;
      });

      //pre-haps give these buttons a sort class and $(".sort").on('click', function() { doGenericThing() })
      $("#sort_by_name").on('click', function(event) {
        event.preventDefault();

        const sortedCards = cards.sort((a,b) => a.name.localeCompare(b.name))
        generateAndDisplayHTML(sortedCards);
        createEventListener();
      });

      $("#sort_by_id").on('click', function(event) {
        event.preventDefault();
        
        const sortedCards = cards.sort((a,b) => a.multiverse_id - b.multiverse_id)
        generateAndDisplayHTML(sortedCards);
        createEventListener();
      });

      //this sorts only by the prices on CardKingdom, as other prices are only suggestions
      $("#sort_by_price").on('click', function(event) {
        event.preventDefault();

        const sortedCards = cards.sort((a,b) => {
          const [priceA, priceB] = [a, b].map(card=> parseFloat(card.price[1].match(/\d+\,*\d*\.*\d*/)))
          return priceB - priceA;
        });

        generateAndDisplayHTML(sortedCards);
        createEventListener();
      });

      $("#sort_by_color").on('click', function(event) {
        event.preventDefault();

        const colorWeights = {
          'White' : 1,
          'Blue'  : 2,
          'Black' : 3,
          'Red'   : 4,
          'Green' : 5,
          'Colorless' : 6,
          'Gold'  : 7
        }
        
        const sortedCards = cards.sort((a,b)=> colorWeights[a.color] - colorWeights[b.color])
        generateAndDisplayHTML(sortedCards);
        createEventListener();
      });

      $("#sort_by_type").on('click', function(event) {
        event.preventDefault();

        const typeOrder = { 
          'Land': 1, 
          'Basic': 1, 
          'Artifact': 2, 
          'Instant': 3, 
          'Sorcery': 4, 
          'Enchantment': 5, 
          'Creature': 6 
        }
        
        const sortedCards = cards.sort((a,b)=> typeOrder[a.card_type] - typeOrder[b.card_type])

        generateAndDisplayHTML(sortedCards);
        createEventListener();
      });

      //clear "sort by" buttons when a card is clicked.
      function createEventListener() {
        $(".thumb").on('click', function() {
          $("a.btn-sm").empty()
          document.getElementById("pagination-pg-num").style = "display: none;";
          $("div#find-by-pagination")[0].innerHTML = null;
        })
      }
      createEventListener();
    });
  });

});