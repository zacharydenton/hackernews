@fetchArticle = ->
  post = Session.get 'post'
  return unless post?
  Session.set 'post_article', null
  $.getJSON "http://viewtext.org/api/text?url=#{post.url}&callback=?", (data) ->
    Session.set 'post_article', data.content

Template.post_read.post = ->
  post = Session.get('post')
  fetchPost(Session.get('post_id')) unless post?
  return post

Template.post_read.text = ->
  post = Session.get 'post'
  article = Session.get 'post_article'
  if post?
    fetchArticle() unless article?
  else
    fetchPost(Session.get('post_id'))
  return article
