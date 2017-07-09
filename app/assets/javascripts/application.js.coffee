# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https:#github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require turbolinks
#= require head
#= require moment
#= require dist/semantic.min.js
#= require_tree ./models/
#= require_tree ./controllers/
#= require_tree ./views/

pageLoad = ->
  class_name = $('body').attr('data-class-name')
  action_name = $('body').attr('data-class-action')
  window.applicationView = try
    controller = eval("new " + class_name + "()")
    eval("controller." + action_name + "()")
  catch error
    homepage = new Controllers.Homepage()
    homepage.show()

head ->
  $ ->
    pageLoad()
    $(document).on 'page:load', pageLoad
    $(document).on 'page:before-change', ->
# clear up
      true
    $(document).on 'page:restore', ->
# something
      pageLoad()
      true