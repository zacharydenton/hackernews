Handlebars.registerHelper 'ifEqual', (context, options) ->
  if context == options.hash.compare
    return options.fn(this)
  return options.inverse(this)

Handlebars.registerHelper 'pluralize', (number, single, plural) ->
  return single if number == 1
  return plural

Handlebars.registerHelper 'active', (path) ->
  if Meteor.Router.page() == path then 'active' else ''

Handlebars.registerHelper 'ago', (datetime) ->
  moment(datetime).fromNow()

Handlebars.registerHelper 'namedRoute', (name, args...) ->
  route = Meteor.Router["#{name}Path"]
  route? && route.apply(this, args)

Handlebars.registerHelper 'svgSupported', ->
  Modernizr.svg

Handlebars.registerHelper 'isCrawler', ->
  console.log window.location.href.indexOf('_escaped_fragment_')
  window.location.href.indexOf('_escaped_fragment_') >= 0
