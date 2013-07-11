fetchPosts = (opts) ->
  params =
    limit: 100
    filter:
      fields:
        type: "submission"
  if opts.params?
    params = $.extend params, opts.params
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
    posts = Session.get('posts') ? {}
    posts[opts.id] = data.results
    Session.set 'posts', posts

Template.posts_top.topHandle =
  id: 'top'
  params:
    sortby: 'points desc'
    filter:
      fields:
        create_ts: '[NOW-24HOURS TO NOW]'

Template.posts_new.newHandle =
  id: 'new'
  params:
    sortby: 'create_ts desc'

Template.posts_ask.askHandle =
  id: 'ask'
  params:
    q: '"Ask HN"'
    sortby: 'create_ts desc'

Template.posts_list.posts = ->
  posts = Session.get('posts')
  if (posts? and posts[@id]?)
    return posts[@id]
  else
    fetchPosts(this)
    return null

