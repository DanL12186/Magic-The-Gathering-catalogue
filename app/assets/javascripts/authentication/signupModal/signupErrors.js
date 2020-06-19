document.addEventListener('turbolinks:load', () => {
  const signupForm = document.getElementById('signupForm')

  const populateErrors = JSON => {
    for (const errorKey in JSON) {
      const capitalizedKey = errorKey.replace(/^\w/, letter => letter.toUpperCase())

      for (const errorMessage of JSON[errorKey]) {
        const errorDiv = `<div> ${capitalizedKey} ${errorMessage} </div>`;

        document.getElementById('signupError').innerHTML += errorDiv;
      }
    }
  }

  //Display all errors for user if signup fails
  if (signupForm) {
    signupForm.addEventListener('submit', function(event) {
      event.preventDefault()
      event.stopPropagation()
      
      const form = $(this).serialize()
      const request = $.post('/signup', form)

      document.getElementById('signupError').innerHTML = ''

      //response should only happen on error, else page redirects
      request.done(jsonResponse => {
        if (jsonResponse) {
          populateErrors(jsonResponse)
        }
      })
    })
  }

})