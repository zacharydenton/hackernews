@fetchPost = (id) ->
  return if Session.get 'receivingData'
  Session.set 'receivingData', true
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/#{id}?callback=?", (data) ->
    Session.set 'post', data
    Session.set 'comments', null

Template.post_page.haveComments = ->
  Session.get('comments')?

Template.post_page.post = ->
  post = Session.get('post')
  fetchPost(Session.get('post_id')) unless post?
  return post

Template.post_page.events =
  'click .toggle': (e) ->
    if $('.toggle').text() == 'Collapse All'
      $('.comments .comments').slideUp()
      $('.toggle').text('Expand All')
    else
      $('.comments .comments').slideDown()
      $('.toggle').text('Collapse All')
