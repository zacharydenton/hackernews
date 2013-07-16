Meteor.Router.beforeRouting = ->
  Session.set 'receivingData', false

scopedPostList = (name, scope) ->
  scope = "day" unless scope?
  if scope != Session.get('scope')
    Session.set 'scope', scope
    refreshPosts name
  name

Meteor.Router.add
  '/': 'posts_front'
  '/new': 'posts_new'
  '/top/:scope?': as: 'posts_top', to: (scope) ->
    scopedPostList 'posts_top', scope
  '/ask/:scope?': as: 'posts_ask', to: (scope) ->
    scopedPostList 'posts_ask', scope
  '/search/:query/:sortBy?': as: 'posts_search', to: (query, sortBy) ->
    name = Meteor.Router.page()
    refresh = false
    if query != Session.get('search')
      Session.set 'search', query
      refresh = true
    sortBy = "relevance" unless sortBy?
    if sortBy != Session.get('sortBy')
      Session.set 'sortBy', sortBy
      refresh = true
    if refresh
      refreshPosts 'posts_search'
    'posts_search'
  '/posts/:post_id': as: 'post_page', to: (post_id) ->
    post = Session.get 'post'
    if post? and post._id isnt post_id
      Session.set 'post', null
    Session.set 'post_id', post_id
    'post_page'
  '/posts/:post_id/read': as: 'post_read', to: (post_id) ->
    Session.set 'post_id', post_id
    'post_read'

