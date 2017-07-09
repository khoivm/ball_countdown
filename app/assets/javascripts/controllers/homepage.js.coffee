window.Controllers.Homepage ||= {}
class Controllers.Homepage extends Controllers.ApplicationController

  constructor: ->

  show: ->
    homepage = new Views.Homepage()
    homepage.show()
