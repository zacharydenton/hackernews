Template.post_item.link = ->
  if @url?
    @url
  else
    "http://news.ycombinator.com/item?id=#{@id}"

Template.post_item.events =
  'click .comments': (e) ->
    e.preventDefault()
    window.location = "http://news.ycombinator.com/item?id=#{@id}"
