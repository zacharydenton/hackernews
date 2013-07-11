fetchPosts = ->
  params = 
    'limit': 30
    'sortby': 'product(points,pow(2,div(div(ms(create_ts,NOW),3600000),72))) desc'
  $.getJSON 'http://api.thriftdb.com/api.hnsearch.com/items/_search?callback=?', params, (data) ->
    Session.set 'posts', data.results

Template.posts_list.posts = ->
  posts = Session.get 'posts'
  fetchPosts() unless posts?
  posts

