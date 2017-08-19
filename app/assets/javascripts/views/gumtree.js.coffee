window.Gumtree ||= {}
class Views.Gumtree extends Views.ApplicationView
  me = null
  INTERVAL = 30

  constructor: ->
    super
    me = this

  show: ->
    $('.ui.sticky').sticky({
      context: '#context'
    })
    show_gumtree_list()
    set_event_submit_watcher()
    set_event_watcher_click()
    set_event_remove_button()
    set_event_go_button()

  # PRIVATE METHODS #

  set_event_go_button = ->
    $('#matches_list').on('click', '.go_matched_item', () ->
      window.open $(this).closest('.content').find('.header').attr('href')
    )

  set_event_remove_button = ->
    $('#matches_list').on('click', '.remove_matched_item', () ->
      $(this).closest('.item').fadeOut()
      me.setTab(-1, $('#matches_list').find('.item:visible').length)
    )

  set_event_watcher_click = ->
    $('#watchers').on('click', '.label', () ->
      id = $(this).data('id')
      request = Models.Sync.removeGumtreeWatcher(id)
      request.done (data) ->
        $("#watchers .label[data-id=#{id}]").fadeOut()
    )

  set_event_submit_watcher = ->
    $("#save_watcher").on('click', () ->
      watcher = $.trim $('input[name="watcher"]').val()
      return unless watcher

      request = Models.Sync.saveGumtreeWatcher(watcher)
      request.done (data) ->
        add_new_watcher(data)
        $('input[name="watcher"]').val('')
    )

  show_gumtree_list = ->
    $progress = $('#progress')
    $progress.progress({
      total: INTERVAL
    })
    get_gumtree_items()

  get_gumtree_items = ->
    $gumtree_list = $('#gumtree_list')
    $gumtree_list.html('Loading ...')
    response = Models.Sync.getGumtreeItems()
    response.done (data) ->
      show_gumtree_items(data.items)
      show_matched_items(data.matches)
      run_progress()

  run_progress = ->
    clearInterval(window.progress_running)
    $progress = $('#progress')
    $progress.progress('reset')
    window.progress_running = window.setInterval( () ->
      $progress.progress('increment')
      if $progress.progress('is complete')
        clearInterval(window.progress_running)
        get_gumtree_items()
    , 1000);

  add_new_watcher = (data) ->
    $watcher = $("<div class='ui teal tag label' data-id='#{data.id}'>#{data.name}</div>")
    $watcher.hide()
    $("#watchers").append $watcher
    $watcher.fadeIn()

  show_matched_items = (ids) ->
    $matches_list = $('#matches_list')
    $gumtree_list = $('#gumtree_list')
    count = $matches_list.find('.item:visible').length
    for id in ids
      unless $matches_list.find(".item[data-g-id='#{id}']").length
        $item = $($gumtree_list.find(".item[data-g-id='#{id}']")[0].outerHTML)
        $item.find('.time').append(' from ' + moment().format())
        $item.find('.panel').append $('<div class="ui buttons"><button class="ui button remove_matched_item">Remove</button><div class="or"></div><button class="ui positive button go_matched_item">Go</button></div>')
        $matches_list.append $item
        count++
    me.setTab(count)

  show_gumtree_items = (items) ->
    $gumtree_list = $('#gumtree_list')
    if items && items.length
      $gumtree_list.html('')
      for item in items
        template = $gumtree_list.attr('data-template')
        template = template.replace(new RegExp(/_header/g), item.title)
        template = template.replace(new RegExp(/_image_src/g), item.img)
        template = template.replace(new RegExp(/_description/g), item.description)
        template = template.replace(new RegExp(/_time/g), item.time)
#        template = template.replace(new RegExp(/_area/g), item.area)
        template = template.replace(new RegExp(/_location/g), item.location)
        template = template.replace(new RegExp(/_link/g), item.link)
        template = template.replace(new RegExp(/_g_id/g), item.g_id)
        $gumtree_list.append template
    else
      $gumtree_list.html('No items.')