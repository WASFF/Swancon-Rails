
$username = null
$password = null
$login = null
$register = null

showCorrectButtons = (event) ->
  if $username.val().trim().length > 0 || $password.val().trim().length > 0
    unless $register.data("fadeout")
      $register.data("fadeout", true)
      $register.fadeOut ->
        $login.fadeIn ->
          $register.data("fadeout", false)
  else
    unless $login.data("fadeout")
      $login.data("fadeout", true)
      $login.fadeOut ->
        $register.fadeIn ->
          $login.data("fadeout", false)


$(document).ready -> 
  $login_widget = $("#login_widget")
  $username = $login_widget.find("input[name='user[username]']")
  $password = $login_widget.find("input[name='user[password]']")
  $login = $login_widget.find("#login")
  $register = $login_widget.find("#register")
  $login_widget.each (index, item) ->
    $(item).on 'keyup', 'input', showCorrectButtons
    $(item).on 'click', 'input[type=submit]', (event) ->
      $this = $(this)
      if $this.attr("id") == "register"
        window.location = $this.data("url")
        event.preventDefault()

