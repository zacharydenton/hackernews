Template.comments.comments = ->
  comments = Session.get('comments')
  return null unless comments?
  comments[@_id]

Template.comments.events =
  'click li': (e) ->
    containingComment = $(e.target).closest('li')
    $(containingComment).children('.comments').slideToggle()
    false
