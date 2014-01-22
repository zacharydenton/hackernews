Future = Npm.require('fibers/future')

class Cache
  constructor: ->
    @data = {}

  get: (key) ->
    @data[key].value if @data[key]? and not @data[key].expired

  put: (key, value, duration) =>
    Meteor.clearTimeout(@data[key].timeout) if @data[key]?
    @data[key] = value: value, expired: false
    expire = =>
      @data[key].expired = true
    @data[key].timeout = Meteor.setTimeout(expire, duration)

  delete: (key) ->
    delete @data[key]

cache = new Cache()

Meteor.methods
  'readability': (url) ->
    @unblock()
    api = 'http://www.readability.com/api/content/v1/parser'
    params =
      url: url
      token: Meteor.settings.READABILITY_TOKEN
    res = Meteor.http.get api, params: params
    res.data
  'frontPage': (count, offset) ->
    if cache.get('frontPage')
      return cache.get('frontPage').slice(offset, offset + count)
    @unblock()
    api = 'http://query.yahooapis.com/v1/public/yql'
    params =
      q: "select * from feed where url='http://hnsearch.com/bigrss'"
      format: 'json'
    res = Meteor.http.get api, params: params
    data = res.data
    if data?.query?.results?.item?
      results = (result for result in data.query.results.item when result.hnsearch_id?)
      cache.put('frontPage', results, 600000)
      return results.slice(offset, offset + count)
    else
      if cache.data['frontPage']?
        return cache.data['frontPage'].value.slice(offset, offset + count)
      else
        return []
