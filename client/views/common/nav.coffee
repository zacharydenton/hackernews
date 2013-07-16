allLists = [
  {title: "Front Page", name: "posts_front"},
  {title: "Top Posts", name: "posts_top"},
  {title: "New Posts", name: "posts_new"},
  {title: "Ask HN", name: "posts_ask"},
]

allScopes = [
  {title: "All Time", name: "all"},
  {title: "Year", name: "year"},
  {title: "Week", name: "week"},
  {title: "Day", name: "day"},
]

refreshPosts = (key) ->
  posts = Session.get 'posts'
  offsets = Session.get 'offsets'
  if posts? and posts[key]?
    posts[key] = null
    Session.set 'posts', posts
  if offsets? and offsets[key]?
    offsets[key] = 0
    Session.set 'offsets', offsets

Template.nav.post = ->
  Session.get 'post'

Template.nav.article = ->
  post = Session.get 'post'
  post? && post.url?

Template.nav.searching = ->
  Session.get 'searching'

Template.nav.reading = ->
  Meteor.Router.page() == 'post_read'

currentItem = (currentName, items) ->
  (item for item in items when item.name is currentName)[0]

otherItems = (currentName, items) ->
  (item for item in items when item.name isnt currentName)

Template.nav.currentList = ->
  currentItem Meteor.Router.page(), allLists

Template.nav.otherLists = ->
  otherItems Meteor.Router.page(), allLists

Template.nav.currentScope = ->
  currentItem Session.get('scope'), allScopes

Template.nav.otherScopes = ->
  otherItems Session.get('scope'), allScopes

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
