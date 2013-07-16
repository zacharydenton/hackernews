Template.body.rendered = ->
  hammer = $('body').hammer()
  hammer.on 'swiperight', ->
    history.back()
