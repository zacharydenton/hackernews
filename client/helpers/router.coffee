Meteor.Router.beforeRouting = ->
  document.title = 'HackerReader'

Handlebars.registerHelper 'active', (path) ->
  if Meteor.Router.page() == path then 'active' else ''

Meteor.Router.add
  '/': 'posts_top'
  '/new': 'posts_new'
  '/ask': 'posts_ask'
  '/search': 'posts_search'
