$(document).on('turbolinks:load', function() {

  //clear "sort by" buttons when a card is clicked.
  function listenForPageLeave() {
    $(".thumb").on('click', function() {
      $("a.btn-sm").empty()
      document.getElementById("pagination-pg-num").style = "display: none;";
      $("div#find-by-pagination")[0].innerHTML = null;
    })
  }

  //change edition symbol color to silver or gold if card is uncommon or rare
  function listenForThumbHover() {
    const grabEdition = currentElement => currentElement.parentElement.parentElement.previousElementSibling.firstElementChild

    $(".thumb").on('mouseenter', function() {
      const cardEditionSymbol = grabEdition(this)
      const edition = this.parentElement.parentElement.previousElementSibling.getAttribute('data-edition').replace(/_/g,' ')
      ,     rarity  = cardEditionSymbol.getAttribute('class').replace(/^common/, '')
      cardEditionSymbol.src = `/assets/editions/${edition} ${rarity}`;
    }).on('mouseleave', function() {
      const edition = this.parentElement.parentElement.previousElementSibling.getAttribute('data-edition').replace(/_/g,' ')
      const cardEditionSymbol = grabEdition(this)
      cardEditionSymbol.src = `/assets/editions/${edition}`;
    });
  };
  
  //for when user clicks off page and then backclicks
  listenForThumbHover();

  const truncateLongNames = name => name.length > 25 ? `${name.slice(0,20).trim()}...` : name

  //populate /cards/find_by_properties with found cards
  $("form.find_by_properties").on('submit', function(event) {
    event.stopPropagation();
    event.preventDefault();
    
    function generateCardsHTML(cards, currentPage) {
      const slice = currentPage * 60
      return cards.map(card=> {
        const shortName = truncateLongNames(card.name)
        ,     cardClass = card.edition === 'Alpha' ? 'thumb alpha' : 'thumb'
        ,     thumbnail = card.hi_res_img.replace('large','small')
        ,     edition   = card.edition.toLowerCase().replace(':','')
        ,     rarity    = card.rarity.toLowerCase();
        
        return( 
          `<div class= col-sm-3>
            <h3 data-edition= ${edition.replace(/ /g, '_')} data-rarity=${rarity} style="font-family: MagicMedieval; font-size:1.5vw; min-height:32px;"> 
              ${shortName} <img src="/assets/editions/${edition}" class=${rarity} width=6% >
            </h3>
            
            <div class=card_img_div> 
              <a href="/cards/${card.name}/"> <img src="${thumbnail}" class="${cardClass}" style="width: 146px; height: 204px;"> </a>
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
    
    response.done(response => {
      const cards = response ? response.map(JSON=> JSON.attributes) : null

      //remove 'Page:' and page tabs if all one page
      if (!cards || cards.length <= 60) {
        document.getElementById("find-by-pagination").innerHTML = null;
        document.getElementById("pagination-pg-num").style = "display: none;"
      }

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
      
      //change page tabs if necessary
      if (numPages > 1 && document.getElementsByClassName("jslink").length !== numPages) {
        document.getElementById("pagination-pg-num").style = "display: block"
        document.getElementById("find-by-pagination").innerHTML += `<span> </span>`
        let pageButtons = '';

        for (let i = 0; i < numPages; i++) {
          pageButtons += `<button class="btn-group-sm jslink"> ${i} </button>`;
        }

        $("div#find-by-pagination")[0].innerHTML = pageButtons
      };

      displayResults(html);

      //create buttons to sort newly displayed card results
      //could make sort buttons into a dropdown instead for space reasons
      document.getElementById("sort_by_name").innerHTML = `<button>Sort By Name</button>`
      document.getElementById("sort_by_id").innerHTML = `<button>Sort By Multiverse ID</button>`
      document.getElementById("sort_by_price").innerHTML = `<button>Sort By Price</button>`

      //remove/don't display buttons to sort by properties that are already filtered for
      if ($("#color")[0].value === '') {
        document.getElementById("sort_by_color").innerHTML = `<button>Sort By Color</button>`
      } else {
        $("#sort_by_color").empty();
      }

      if ($("#card_type")[0].value === '') {
        document.getElementById("sort_by_type").innerHTML = `<button>Sort By Type</button>`
      } else {
        $("#sort_by_type").empty();
      }

      listenForPageLeave();
      listenForThumbHover();

      $(".jslink").on('click', function(event) {
        event.preventDefault();

        generateAndDisplayHTML(cards, parseInt(this.innerHTML))

        listenForPageLeave();
        listenForThumbHover();
        return;
      });

      const colorOrder = {
        'White' : 1,
        'Blue'  : 2,
        'Black' : 3,
        'Red'   : 4,
        'Green' : 5,
        'Colorless' : 6,
        'Gold'  : 7
      }, typeOrder = {
          'Land': 1, 
          'Basic': 1, 
          'Artifact': 2, 
          'Instant': 3, 
          'Sorcery': 4, 
          'Enchantment': 5, 
          'Creature': 6 
      };

      //sort by price sorts only by the prices on CardKingdom, as other prices are only suggestions
      const sortButtonFunctions = {
        'sort_by_id' : fn => cards.sort((a,b) => a.multiverse_id - b.multiverse_id),
        'sort_by_name' : fn => cards.sort((a,b) => a.name.localeCompare(b.name)),
        'sort_by_color' : fn => cards.sort((a,b)=> colorOrder[a.color] - colorOrder[b.color]),
        'sort_by_type' : fn => cards.sort((a,b)=> typeOrder[a.card_type] - typeOrder[b.card_type]),
        'sort_by_price' : fn => cards.sort((a,b) => parseFloat(b.price[1]) - parseFloat(a.price[1]))
      }

      $(".sort").on('click', function(event) {
        event.preventDefault();

        const buttonId = event.currentTarget.id
        ,     sortedCards = sortButtonFunctions[buttonId]();

        generateAndDisplayHTML(sortedCards);

        listenForPageLeave();
        listenForThumbHover();
      });
    });
  });

});