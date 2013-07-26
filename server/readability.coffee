Future = Npm.require 'fibers/future'
readability = Meteor.require 'node-readability'

Meteor.methods
  'readability': (url) ->
    fut = new Future()
    readability.read url, (err, page) ->
      if err or not page?
        fut.ret
          title: null
          content: null
      else
        fut.ret
          title: page.getTitle()
          content: page.getContent()
    fut.wait()
