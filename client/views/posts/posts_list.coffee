fetchPosts = ->
  $.getJSON 'http://api.ihackernews.com/page?format=jsonp&callback=?', (data) ->
    console.log data
    Session.set 'posts', data.items

Template.posts_list.posts = ->
  posts = Session.get 'posts'
  fetchPosts() unless posts?
  posts

