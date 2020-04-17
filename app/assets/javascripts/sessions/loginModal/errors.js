document.addEventListener('turbolinks:load', function() {
  const loginForm = document.getElementById('loginForm')
  
  //let user know if login failed
  loginForm.addEventListener('submit', function(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const form = $(this).serialize()
    const request = $.post('/login', form)

    document.getElementById('loginError').innerHTML = ''

    request.done(response => {
      if (response === "Authentication failed") {
        document.getElementById('loginError').innerHTML = response
      }
    })

    
  })

})