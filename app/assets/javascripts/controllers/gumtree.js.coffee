window.Controllers.Gumtree ||= {}
class Controllers.Gumtree extends Controllers.ApplicationController

  constructor: ->

  Index: ->
    index = new Views.Gumtree()
    index.show()
