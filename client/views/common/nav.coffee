refreshPosts = (key) ->
  posts = Session.get 'posts'
  if posts? and posts[key]?
    posts[key] = null
    Session.set 'posts', posts

Template.nav.searching = ->
  Session.get 'searching'

Template.nav.events
  'click .refresh': (e) ->
    e.preventDefault()
    e.stopPropagation()
    refreshPosts Meteor.Router.page()
  'click .search': (e) ->
    e.preventDefault()
    e.stopPropagation()
    Session.set 'searching', true
  'keypress .search-form': (e) ->
    if e.keyCode == 13 # enter
      e.preventDefault()
      e.stopPropagation()
      Session.set 'search', e.srcElement.value
      Session.set 'searching', false
      refreshPosts 'posts_search'
      Meteor.Router.to 'posts_search'
  'blur .search-form input': (e) ->
    Session.set 'searching', false
