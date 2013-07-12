Template.sidebar.post = ->
  Session.get 'post'

Template.sidebar.reading = ->
  Meteor.Router.page() == 'post_read'
