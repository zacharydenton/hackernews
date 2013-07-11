fetchPosts = (opts) ->
  $.getJSON "#{opts.url}?format=jsonp&callback=?", (data) ->
    posts = Session.get('posts') ? {}
    posts[opts.id] = data.items
    Session.set 'posts', posts

Template.posts_top.topHandle =
  id: 'top'
  url: 'http://api.ihackernews.com/page'

Template.posts_new.newHandle =
  id: 'new'
  url: 'http://api.ihackernews.com/new'

Template.posts_ask.askHandle =
  id: 'ask'
  url: 'http://api.ihackernews.com/ask'

Template.posts_list.posts = ->
  posts = Session.get('posts')
  if (posts? and posts[@id]?)
    return posts[@id]
  else
    fetchPosts(this)
    return null

