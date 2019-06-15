document.addEventListener('turbolinks:load', function() {
  const datalist = this.getElementById('autocomplete')
  
  //clear search bar on page refresh
  this.getElementById('search').value = ''

  let cardNames,
      lastMatch;

  document.getElementById('search').addEventListener('focus', () => {
    if (!cardNames) {
      const response = $.get('/cards/card_names');
      response.done(names => {
        cardNames = names.sort()
      })
    }
  });

  //autocomplete search for finding cards by name
  document.getElementById('search').addEventListener('keyup', event => {
    if (event.target.value) {
      const userEntry         = event.target.value.toLowerCase()
      ,     matches           = cardNames.filter(name=> name.toLowerCase().startsWith(userEntry))
      ,     firstEightMatches = matches.slice(0,8);

      //only update on change
      if (lastMatch !== firstEightMatches.toString()) {
        datalist.innerHTML = firstEightMatches.map(match=> `<option value="${match}"></option>`);
        lastMatch = firstEightMatches.toString();
      };
    };
  });
});
