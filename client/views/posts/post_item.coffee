Template.post_item.commentsLink = ->
  id = @_id ? @hnsearch_id
  return "" unless id?
  Meteor.Router.post_pagePath id

Template.post_item.readLink = ->
  id = @_id ? @hnsearch_id
  return "" unless id?
  Meteor.Router.post_readPath id

Template.post_item.isArticle = ->
  @url? or @link?

Template.post_item.external_link = ->
  if @url?
    @url
  else if @link?
    @link
  else if @comments?
    @comments
  else
    "http://news.ycombinator.com/item?id=#{@id}"
