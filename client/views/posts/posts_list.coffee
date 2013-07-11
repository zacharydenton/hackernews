fetchFrontPage = ->
  $.getJSON "http://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20feed%20where%20url%3D'http%3A%2F%2Fhnsearch.com%2Fbigrss'&format=json&callback=?", (data) ->
    posts = Session.get('posts') ? {}
    posts[Meteor.Router.page()] = data.query.results.item
    Session.set 'posts', posts

fetchPosts = (opts) ->
  if Meteor.Router.page() == 'posts_front'
    return fetchFrontPage()
  params =
    limit: 100
  if opts.params?
    params = $.extend params, opts.params
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data) ->
    posts = Session.get('posts') ? {}
    posts[Meteor.Router.page()] = (result.item for result in data.results)
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

Template.posts_list.rendered = ->
  currentScroll = Session.get 'currentScroll'
  if currentScroll? and Session.get('posts')?
    $('.content').scrollTop currentScroll
    Session.set 'currentScroll', null

Template.posts_list.events =
  'click .posts-list li': (e) ->
    Session.set 'currentScroll', $('.content').scrollTop()
