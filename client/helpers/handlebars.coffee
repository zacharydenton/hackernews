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
  Meteor.Router["#{name}Path"].apply this, args

Handlebars.registerHelper 'svgSupported', ->
  Modernizr.svg
