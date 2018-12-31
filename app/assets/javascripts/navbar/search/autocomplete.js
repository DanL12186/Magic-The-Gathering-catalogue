$(document).on('turbolinks:load', function() {
  
  let cardNames,
      lastMatch;

  $('#search').on('focus', ()=> {
    if (!cardNames) {
      const response = $.get('/cards/card_names');
      response.done(names => {
        cardNames = names.sort()
      })
    }
  });

  //at the moment, from a performance standpoint it makes more sense to search and then sort the results each time.
  //If performance were ever really an issue, though, sorting once as above and then breaking after eight matches are found, while less concise,
  //would certainly be the way to go

  //autocomplete search for finding cards by name
  $('#search').on('keyup', event => {
    if (event.target.value) {
      const userEntry = event.target.value.toLowerCase()
      ,     matches = cardNames.filter(name=> name.toLowerCase().startsWith(userEntry))
      ,     datalist = document.getElementById('autocomplete')
      ,     firstEightMatches = matches.slice(0,8);

      //only update on change
      if (lastMatch !== firstEightMatches.toString()) {
        datalist.innerHTML = firstEightMatches.map(match=> `<option value="${match}" style="font-family: MagicMedieval;"></option>`);
      };

      lastMatch = firstEightMatches.toString();
    };
  });
});