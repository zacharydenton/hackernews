fetchPost = (id) ->
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/#{id}?callback=?", (data) ->
    Session.set 'post', data
    Session.set 'comments', null
    comments = []
    num_comments = data.num_comments
    fetchComments = (start) ->
      params =
        limit: 100
        sortby: 'create_ts asc'
        start: start
        filter:
          fields:
            'discussion.sigid': id
      $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
        comments = comments.concat data.results
        start += 100
        if start < num_comments
          fetchComments start
        else
          dictionary = {}
          for comment in comments
            dictionary[comment.item.parent_sigid] ?= []
            dictionary[comment.item.parent_sigid].push comment
          Session.set 'comments', dictionary
    fetchComments 0

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