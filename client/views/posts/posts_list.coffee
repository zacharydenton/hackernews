fetchPosts = (opts) ->
  params =
    limit: 100
  if opts.params?
    params = $.extend params, opts.params
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
    posts = Session.get('posts') ? {}
    posts[Meteor.Router.page()] = data.results
    Session.set 'posts', posts

Template.posts_top.topHandle =
  params:
    sortby: 'points desc'
    filter:
      fields:
        create_ts: '[NOW-24HOURS TO NOW]'
        type: "submission"

Template.posts_new.newHandle =
  params:
    sortby: 'create_ts desc'
    filter:
      fields:
        type: "submission"

Template.posts_ask.askHandle =
  params:
    q: '"Ask HN"'
    sortby: 'num_comments desc'
    filter:
      fields:
        create_ts: '[NOW-24HOURS TO NOW]'
        type: "submission"

Template.posts_search.searchHandle = ->
  params:
    q: Session.get 'search'
    filter:
      fields:
        type: "submission"
    weights:
      title: 1.1
      text: 0.7
      url: 1.0
      domain: 2.0
      username: 0.1
      type: 0.0
    boosts:
      fields:
        points: 0.15
        num_comments: 0.15
      functions:
        "pow(2,div(div(ms(create_ts,NOW),3600000),72))": 200.0

Template.posts_list.posts = ->
  posts = Session.get('posts')
  if (posts? and posts[Meteor.Router.page()]?)
    return posts[Meteor.Router.page()]
  else
    fetchPosts(this)
    return null

