Future = Npm.require('fibers/future')

Meteor.methods
  'readability': (url) ->
    @unblock()
    fut = new Future()
    opts =
      params:
        url: url
        token: Meteor.settings.READABILITY_TOKEN
    Meteor.http.get 'http://www.readability.com/api/content/v1/parser', opts, (err, res) ->
      fut.return res.data
    fut.wait()
