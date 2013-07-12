Meteor.Router.beforeRouting = ->
  document.title = 'HackerReader'

Meteor.Router.add
  '/': 'posts_front'
  '/top': 'posts_top'
  '/new': 'posts_new'
  '/ask': 'posts_ask'
  '/search': 'posts_search'
  '/posts/:post_id': as: 'post_page', to: (post_id) ->
    post = Session.get 'post'
    if post? and post._id isnt post_id
      Session.set 'post', null
    Session.set 'post_id', post_id
    'post_page'
  '/posts/:post_id/read': as: 'post_read', to: (post_id) ->
    Session.set 'post_id', post_id
    'post_read'

