$(document).on('turbolinks:load', function() {
  'use strict';

  //clear "sort by" and page buttons when a card is clicked
  function listenForPageLeave() {
    document.addEventListener('turbolinks:before-visit', () => {
      $("a.btn-sm").empty()
      $('#pagination-pg-num').empty()
      $('div#find-by-pagination').empty()
    })
  }

  //change set/edition symbol color to silver or gold if card is uncommon or rare
  function listenForThumbHover() {
    const getCardHeading = cardThumb   => cardThumb.parentElement.parentElement.previousElementSibling,
          getCardSetIcon = cardHeading => cardHeading.firstElementChild,
          getCardSet     = cardHeading => cardHeading.getAttribute('data-edition');

    $('.thumb').on('mouseenter', event => {
      const heading      = getCardHeading(event.target),
            edition      = getCardSet(heading),
            cardSetIcon  = getCardSetIcon(heading),
            rarity       = cardSetIcon.getAttribute('class').replace(/^common|special/i, '');

      cardSetIcon.src = `/assets/editions/${edition} ${rarity}`;
    }).on('mouseleave click', event => {
      const heading     = getCardHeading(event.target),
            edition     = getCardSet(heading),
            cardSetIcon = getCardSetIcon(heading);

      cardSetIcon.src = `/assets/editions/${edition}`;
    });
  };
  
  //for when user clicks off page and then backclicks
  listenForThumbHover();

  const truncateLongNames = name => name.length > 25 ? `${name.slice(0,20).trim()}...` : name

  //probably good candidate for an object/class
  function generateCardsHTML(cards, currentPage) {
    const slice = (currentPage - 1) * 60
    return cards.map(card => {
      const shortName = truncateLongNames(card.name),
            cardClass = card.edition === 'Alpha' ? 'thumb alpha' : 'thumb',
            thumbnail = card.hi_res_img.replace('large','small'),
            edition   = card.edition.toLowerCase().replace(':', ''),
            rarity    = card.rarity.toLowerCase();
      
      return( 
        `<div class= col-sm-3>
          <h3 class="thumb-header" data-edition= "${edition}" data-rarity=${rarity}> 
            ${shortName} <img src="/assets/editions/${edition}" class=${rarity} width=6% >
          </h3>
          
          <div class=card_img_div> 
            <a href="/cards/${card.edition}/${card.name}/"> <img src="${thumbnail}" class="${cardClass}"> </a>
          </div>
          
        </div>`
      )
      
    }).slice(slice, slice + 60).join('')
  };

  function displayResults(results) {
    document.getElementById("find_cards").innerHTML = results;
  }

  function generateAndDisplayHTML(sortedResult, currentPage = 1) {
    const sortedHTML = generateCardsHTML(sortedResult, currentPage)
    displayResults(sortedHTML, currentPage)
  }
  
  const submitButton = document.getElementById("find_submit")

  //form will disable the submit button when it's submitted. This listens for when user 
  //makes a different or additional selection on the form and re-enables the submit button
  function listenForFormChange() {
    $("#find_by_properties").on('change', () => submitButton.removeAttribute('disabled') );
  }

  listenForFormChange();

  //populate /cards/find_by_properties with found cards
  $("#find_by_properties").on('submit', function(event) {
    event.stopPropagation();
    event.preventDefault();

    //disable button until form changes to prevent spamming
    submitButton.setAttribute('disabled', true)

    const serializedForm = $(this).serialize()
    const response = $.post(`/cards/find_by_properties`, serializedForm);
    
    response.done(response => {
      //filter out cards which don't have prices from cardkingdom
      const cards = response ? response.map(JSON=> JSON.attributes).filter(card=> parseFloat(card.prices[1])) : null

      //remove 'Page:' and page tabs if all one page
      if (!cards || cards.length <= 60) {
        document.getElementById("find-by-pagination").innerHTML = null;
        document.getElementById("pagination-pg-num").style = "display: none;"
      }

      if (cards === null) {
        $("a.btn-sm").empty()
        return displayResults('Please Select One or More Options')
      } else if (!cards.length) {
        $("a.btn-sm").empty()
        return displayResults("No results found")
      }

      const numPages = Math.ceil(cards.length / 60)
      ,     html = generateCardsHTML(cards, 1);
      
      //change page tabs if necessary
      if (numPages > 1 && document.getElementsByClassName("jslink").length !== numPages) {
        document.getElementById("pagination-pg-num").style = "display: block"
        document.getElementById("find-by-pagination").innerHTML += `<span> </span>`
        
        let pageButtons = '';

        for (let i = 1; i <= numPages; i++) {
          pageButtons += `<button class="btn-group-sm jslink"> ${i} </button>`;
        }

        $("div#find-by-pagination")[0].innerHTML = pageButtons
      };

      displayResults(html);

      //create buttons to sort newly displayed card results
      //could make sort buttons into a dropdown instead for space reasons
      document.getElementById("sort_by_name").innerHTML  = `<button>Sort By Name</button>`
      document.getElementById("sort_by_id").innerHTML    = `<button>Sort By Multiverse ID</button>`
      document.getElementById("sort_by_price").innerHTML = `<button>Sort By Price &#9660</button>`

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
          'Land'    : 1, 
          'Basic'   : 1, 
          'Artifact': 2, 
          'Instant' : 3, 
          'Sorcery' : 4, 
          'Enchantment': 5, 
          'Creature': 6
      };

      //sort by price sorts only by the prices on CardKingdom, as other prices are only suggestions
      const sortButtonFunctions = {
        'sort_by_id'    : () => cards.sort((a,b) => a.multiverse_id - b.multiverse_id),
        'sort_by_name'  : () => cards.sort((a,b) => a.name.localeCompare(b.name)),
        'sort_by_color' : () => cards.sort((a,b) => colorOrder[a.color] - colorOrder[b.color] || a.name.localeCompare(b.name)),
        'sort_by_type'  : () => cards.sort((a,b) => typeOrder[a.card_type] - typeOrder[b.card_type] || a.name.localeCompare(b.name)),
        'sort_by_price' : () => cards.sort((a,b) => parseFloat(b.prices[1]) - parseFloat(a.prices[1]) || a.name.localeCompare(b.name))
      }

      $(".sort").on('click', event => {
        const buttonId = event.currentTarget.id;
        const sortedCards = sortButtonFunctions[buttonId]();
        
        generateAndDisplayHTML(sortedCards);

        listenForPageLeave();
        listenForThumbHover();
      });
    });
  });

});
