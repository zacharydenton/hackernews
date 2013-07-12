renderComments = (comments) ->
  post = Session.get 'post'
  return unless post?
  comments_dict = {}
  for comment in comments
    comments_dict[comment.item.parent_sigid] ?= []
    comments_dict[comment.item.parent_sigid].push comment

  renderLevel = (parent_sigid, depth) ->
    return "" unless comments_dict[parent_sigid]?
    result = ""
    for comment in comments_dict[parent_sigid]
      html = Template.comment(comment.item)
      children = renderLevel(comment.item._id, depth + 1)
      result += "<li>#{html + children}</li>"
    "<ul class='comments'>#{result}</ul>"

  renderLevel(post._id, 0)

@fetchAllComments = ->
  post = Session.get 'post'
  return unless post?
  Session.set 'comments', null
  comments = []
  num_comments = post.num_comments
  fetchCommentsBatch = (start) ->
    params =
      limit: 100
      start: start
      sortby: 'product(num_comments,product(points,pow(2,div(div(ms(create_ts,NOW),3600000),72)))) desc'
      filter:
        fields:
          'discussion.sigid': post._id

    $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
      comments = comments.concat data.results
      start += 100
      if start < num_comments
        fetchCommentsBatch start
      else
        Session.set 'comments', renderComments comments
  fetchCommentsBatch 0

fetchComments = ->
  post = Session.get 'post'
  return unless post?
  params =
    limit: 100
    sortby: 'product(num_comments,product(points,pow(2,div(div(ms(create_ts,NOW),3600000),72)))) desc'
    filter:
      fields:
        'discussion.sigid': post._id

  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
    Session.set 'comments', renderComments data.results

Deps.autorun ->
  if not Session.get('comments')? and Session.get('post')?
    fetchComments()

Template.comments.comments = ->
  Session.get 'comments'

Template.comments.events =
  'click a': (e) ->
    window.open $(e.srcElement).attr 'href'
    false
  'click li': (e) ->
    containingComment = $(e.target).closest('li')
    $(containingComment).children('.comments').slideToggle()
    false

Template.comment.points = ->
  if moment(@create_ts) < moment().subtract('days', 5)
    @points
  else
    null
