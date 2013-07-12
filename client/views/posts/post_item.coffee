Template.post_item.link = ->
  Meteor.Router.post_pagePath (@_id ? @hnsearch_id)

Template.post_item.external_link = ->
  if @url?
    @url
  else if @comments?
    @comments
  else
    "http://news.ycombinator.com/item?id=#{@id}"

Template.post_item.events =
  'click .comments': (e) ->
    e.preventDefault()
    window.location = @comments ? "http://news.ycombinator.com/item?id=#{@id}"
  'click .image': (e) ->
    if @url
      e.preventDefault()
      window.location = @url
