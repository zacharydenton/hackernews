Template.load_error.link = ->
  post = Session.get 'post'
  return unless post?
  if post.url? then post.url else "http://news.ycombinator.com/item?id=#{post.id}"

