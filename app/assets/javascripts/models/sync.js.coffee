window.Models.Sync ||= {}
class Models.Sync extends Models.ApplicationModel

  @getGumtreeItems: ->
    request = $.get('/gumtree/items')
    request

  @removeGumtreeWatcher: (id) ->
    request = $.post('/gumtree/remove_watcher', {id: id})
    request

  @saveGumtreeWatcher: (name) ->
    request = $.post('/gumtree/save_watcher', {name: name})
    request
