Future = Npm.require('fibers/future')

class Cache
  constructor: ->
    @data = {}

  get: (key) ->
    @data[key].value if @data[key]?

  put: (key, value, duration) ->
    Meteor.clearTimeout(@data[key].timeout) if @data[key]?
    @data[key] = value: value
    @data[key].timeout = Meteor.setTimeout((=> @delete(key)), duration)

  delete: (key) ->
    Meteor.clearTimeout(@data[key].timeout) if @data[key]?
    @data[key] = null

cache = new Cache()

Meteor.methods
  'readability': (url) ->
    @unblock()
    url = 'http://www.readability.com/api/content/v1/parser'
    params =
      url: url
      token: Meteor.settings.READABILITY_TOKEN
    res = Meteor.http.get url, params: params
    res.data
  'frontPage': (count, offset) ->
    if cache.get('frontPage')?
      return cache.get('frontPage').slice(offset, offset + count)
    @unblock()
    url = 'http://query.yahooapis.com/v1/public/yql'
    params =
      q: "select * from feed where url='http://hnsearch.com/bigrss'"
      format: 'json'
    res = Meteor.http.get url, params: params
    data = res.data
    if data.query? and data.query.results? and data.query.results.item?
      results = (result for result in data.query.results.item when result.hnsearch_id?)
    else
      results = []
    cache.put('frontPage', results, 600000)
    results.slice(offset, offset + count)
