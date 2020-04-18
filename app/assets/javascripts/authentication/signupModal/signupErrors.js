document.addEventListener('turbolinks:load', function() {
  const loginForm = document.getElementById('signupForm')

  //Display all errors for user if signup fails
  loginForm.addEventListener('submit', function(event) {
    event.preventDefault()
    event.stopPropagation()
    
    const form = $(this).serialize()
    const request = $.post('/signup', form)

    document.getElementById('signupError').innerHTML = ''

    //response should only happen on error, else page redirects
    request.done(jsonResponse => {
      if (jsonResponse) {
        for (errorKey in jsonResponse) {
          const capitalizedKey = errorKey.replace(/^\w/, letter => letter.toUpperCase())
          document.getElementById('signupError').innerHTML += `<div>${capitalizedKey} ${jsonResponse[errorKey][0]}</div>`
        }
      }
    })
  })

})