window.Views ||= {}
class Views.ApplicationView

  constructor: ->
    _set_up_elements()

  setTab: (number, total = false) ->
    if total > 0
      number = total + number

    title = $('title').text()
    if new RegExp(/\(\d\) (.*)/).test(title)
      if number <= 0
        $('title').text(title.replace(new RegExp(/\(\d\) (.*)/), '$1'))
      else
        $('title').text(title.replace(new RegExp(/\(\d\) (.*)/), '('+number+') $1'))
    else
      if number > 0
        $('title').prepend('('+number+') ')

  _set_up_elements = ->
    $("#main_setting_icon").on('click', () ->
      $('.ui.sidebar')
        .sidebar('toggle')
      ;
    )
