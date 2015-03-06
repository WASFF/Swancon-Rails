initialiseDropdown = ->
  $dropdowns = $('a.dropdown')

  $dropdowns.click (event) ->
    event.preventDefault()
    event.stopPropagation()
    dropdown = event.currentTarget
    $dropdown = $(event.currentTarget)
    $dropdown.parent().toggleClass 'is-visible'
    $(document).click (event) ->
      if dropdown isnt event.target
        $dropdown.parent().removeClass 'is-visible'

$(document)
  .on 'page:load', initialiseDropdown
  .ready initialiseDropdown