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
    _.each comments_dict[parent_sigid], (comment) ->
      if depth > 1
        comment.item.depth = ((depth - 2) % 4) + 2
      else
        comment.item.depth = 1
      html = Template.comment(comment.item)
      children = renderLevel(comment.item._id, depth + 1)
      replies_hidden = if comment.item.num_comments > 0 then "<div class='replies-hidden'>#{comment.item.num_comments} hidden #{if comment.item.num_comments == 1 then 'comment' else 'comments'}.</div>" else ""
      result += "<li>#{html + children + replies_hidden}</li>"
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
      sortby: 'points desc, num_comments desc'
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
    sortby: 'points desc, num_comments desc'
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

Template.comments.rendered = ->
  unless @keysBound
    @keysBound = true
    @selected = -1
    moveFocus = (offset) =>
      comments = @findAll('.comment:not(.hidden)')
      return unless comments?
      @selected = Math.min(Math.max(@selected + offset, 0), comments.length)
      $(comments[@selected]).focus()
    Mousetrap.bind 'j', =>
      moveFocus +1
    Mousetrap.bind 'k', =>
      moveFocus -1
    Mousetrap.bind 'ctrl+d', =>
      moveFocus +5
    Mousetrap.bind 'ctrl+u', =>
      moveFocus -5
    Mousetrap.bind 'enter', =>
      comments = @findAll('.comment:not(.hidden)')
      return unless comments? and @selected?
      comments[@selected].click()

Template.comments.events =
  'click a': (e) ->
    window.open $(e.srcElement).attr 'href'
    false
  'click li': (e) ->
    containingComment = $(e.target).closest('li')
    $comments = $(containingComment).children('.comments')
    $replies_hidden = $(containingComment).children('.replies-hidden')
    if $comments.css('display') is 'none'
      $comments.show()
      $replies_hidden.hide()
      $comments.find('.comment').removeClass('hidden')
    else
      $comments.hide()
      $replies_hidden.show()
      $comments.find('.comment').addClass('hidden')
    false

Template.comment.points = ->
  if moment(@create_ts) < moment().subtract('days', 5)
    @points
  else
    null

Template.comment.haveReplies = ->
  @num_comments > 0
