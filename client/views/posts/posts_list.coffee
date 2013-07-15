postsPerPage = 30

increasePostOffset = ->
  offsets = Session.get('offsets') ? {}
  offset = offsets[Meteor.Router.page()] ? 0
  offset += postsPerPage
  offsets[Meteor.Router.page()] = offset
  Session.set 'offsets', offsets

renderPosts = (posts) ->
  ("<li>#{Template.post_item(post)}</li>" for post in posts).join ""

fetchFrontPage = ->
  Session.set 'receivingData', true
  offsets = Session.get('offsets') ? {}
  offset = offsets[Meteor.Router.page()] ? 0
  params =
    q: "select * from feed where url='http://hnsearch.com/bigrss' limit #{postsPerPage} offset #{offset}"
    format: 'json'
  $.getJSON "http://query.yahooapis.com/v1/public/yql?callback=?", params, (data) ->
    posts = Session.get('posts') ? {}
    posts[Meteor.Router.page()] ?= ""
    if data.query? and data.query.results? and data.query.results.item?
      results = (result for result in data.query.results.item when result.hnsearch_id?)
    else
      results = []
    if results.length > 0
      posts[Meteor.Router.page()] += renderPosts results
      Session.set 'posts', posts
    else
      haveMore = Session.get('haveMore') ? {}
      haveMore[Meteor.Router.page()] = false
      Session.set 'haveMore', haveMore
    Session.set 'receivingData', false

fetchPosts = (opts) ->
  if Meteor.Router.page() == 'posts_front'
    return fetchFrontPage()
  offsets = Session.get('offsets') ? {}
  offset = offsets[Meteor.Router.page()] ? 0
  return if offset >= 1000 # API limit
  Session.set 'receivingData', true
  params =
    limit: postsPerPage
    start: offset
  if opts.params?
    params = $.extend params, opts.params
  $.getJSON "http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?", params, (data, status, xhr) ->
    posts = Session.get('posts') ? {}
    posts[Meteor.Router.page()] ?= ""
    results = (result.item for result in data.results when result.item._id?)
    if results.length > 0
      posts[Meteor.Router.page()] += renderPosts results
      Session.set 'posts', posts
    else
      haveMore = Session.get('haveMore') ? {}
      haveMore[Meteor.Router.page()] = false
      Session.set 'haveMore', haveMore
    Session.set 'posts', posts
    Session.set 'receivingData', false

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

Template.posts_list.receivingData = ->
  Session.get 'receivingData'

Template.posts_list.posts = ->
  posts = Session.get('posts')
  if (posts? and posts[Meteor.Router.page()]?)
    return posts[Meteor.Router.page()]
  else
    fetchPosts(this)
    return null

Template.posts_list.rendered = ->
  Session.set 'post', null
  Session.set 'post_article', null
  posts = Session.get 'posts'
  currentScroll = Session.get 'currentScroll'
  template = this
  if posts?
    if currentScroll?
      $('.content').scrollTop currentScroll
      Session.set 'currentScroll', null
    infiniteScroll = _.debounce((e) ->
      loading = Session.get 'receivingData'
      haveMore = Session.get('haveMore') ? {}
      haveMore = haveMore[Meteor.Router.page()] ? true
      if $(window).width() > 480
        loadMore = @scrollHeight - $(this).height() - @scrollTop < 500
      else
        loadMore = $('.content').height() - $(window).height() - $(window).scrollTop() < 500
      if loadMore and not loading and haveMore
        increasePostOffset()
        fetchPosts(template.data)
    , 15)
    $('.content').scroll infiniteScroll
    $(window).scroll infiniteScroll

Template.posts_list.events =
  'click .posts-list li': (e) ->
    Session.set 'currentScroll', $('.content').scrollTop()
