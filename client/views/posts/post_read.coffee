@fetchArticle = ->
  post = Session.get 'post'
  return unless post?
  Session.set 'post_article', null
  if post.url?
    Meteor.call 'readability', post.url, (err, data) ->
      if data.content
        data.content = $(data.content).removeClass().html()
      Session.set 'post_article', (data.content or " ")
      Session.set 'loadError', (not data.content)
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
