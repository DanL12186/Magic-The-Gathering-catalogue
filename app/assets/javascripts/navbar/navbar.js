document.addEventListener('turbolinks:load', function() {
  //enables dropdown on click for mobile
  $(".drop-down").on('click', function() {
    if (this.style.display !== 'block') {
      this.style.display = 'block'
    }
  })
})