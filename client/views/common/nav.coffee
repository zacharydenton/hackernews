refreshPosts = (key) ->
  posts = Session.get 'posts'
  if posts? and posts[key]?
    posts[key] = null
    Session.set 'posts', posts

Template.nav.post = ->
  Session.get 'post'

Template.nav.article = ->
  post = Session.get 'post'
  post? && post.url?

Template.nav.searching = ->
  Session.get 'searching'

Template.nav.reading = ->
  Meteor.Router.page() == 'post_read'

Template.nav.events
  'click .refresh': (e) ->
    e.preventDefault()
    e.stopPropagation()
    if Meteor.Router.page() == 'post_page'
      fetchAllComments()
    else if Meteor.Router.page() == 'post_read'
      fetchArticle()
    else
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
