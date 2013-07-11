Template.comments.comments = ->
  comments = Session.get('comments')
  return null unless comments?
  comments[@_id]

Template.comments.events =
  'click a': (e) ->
    window.open $(e.srcElement).attr 'href'
    false
  'click li': (e) ->
    containingComment = $(e.target).closest('li')
    $(containingComment).children('.comments').slideToggle()
    false
