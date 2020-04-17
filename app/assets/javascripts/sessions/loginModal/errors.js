document.addEventListener('turbolinks:load', function() {
  const loginForm = document.getElementById('loginForm')
  
  // very cheap hack until I can get a proper response back from the controller to populate the modal with errors
  loginForm.addEventListener('submit', () => {
    const errorMessage = "Username and password don't match."

    document.getElementById('loginError').innerHTML = ''

    setTimeout(() => {
      document.getElementById('loginError').innerHTML = errorMessage
    }, 400);
  })

})