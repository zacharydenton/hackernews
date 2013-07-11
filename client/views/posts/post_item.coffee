Template.post_item.link = ->
  Meteor.Router.post_pagePath (@_id ? @hnsearch_id)

Template.post_item.external_link = ->
  if @url?
    @url
  else
    "http://news.ycombinator.com/item?id=#{@id}"

Template.post_item.events =
  'click .comments': (e) ->
    e.preventDefault()
    window.location = "http://news.ycombinator.com/item?id=#{@id}"
  'click .image': (e) ->
    if @url
      e.preventDefault()
      window.location = @url
