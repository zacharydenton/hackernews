Template.post_item.link = ->
  id = @_id ? @hnsearch_id
  return "" unless id?
  Meteor.Router.post_pagePath id

Template.post_item.external_link = ->
  if @url?
    @url
  else if @comments?
    @comments
  else
    "http://news.ycombinator.com/item?id=#{@id}"

Template.post_item.events =
  'click .image': (e) ->
    id = @id ? @hnsearch_id
    if id?
      e.preventDefault()
      Meteor.Router.to Meteor.Router.post_readPath(id)
