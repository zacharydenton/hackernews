Meteor.Router.beforeRouting = ->
  document.title = 'HackerReader'

Meteor.Router.add
  '/': 'posts_top'
