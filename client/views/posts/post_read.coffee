@fetchArticle = ->
  post = Session.get 'post'
  return unless post?
  Session.set 'post_article', null
  if post.url?
    params =
      url: post.url
      rl: false
    $.getJSON "http://viewtext.org/api/text?callback=?", params, (data) ->
      Session.set 'post_article', (data.content ? " ")
      Session.set 'loadError', (not data.content?)
  else
    Session.set 'loadError', true

Template.post_read.post = ->
  post = Session.get('post')
  fetchPost(Session.get('post_id')) unless post?
  return post

Template.post_read.error = ->
  Session.get 'loadError'

Template.post_read.text = ->
  post = Session.get 'post'
  article = Session.get 'post_article'
  if post?
    fetchArticle() unless article?
  else
    fetchPost(Session.get('post_id'))
  return article
