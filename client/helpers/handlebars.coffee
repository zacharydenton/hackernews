Handlebars.registerHelper 'active', (path) ->
  if Meteor.Router.page() == path then 'active' else ''

Handlebars.registerHelper 'ago', (datetime) ->
  moment(datetime).fromNow()

