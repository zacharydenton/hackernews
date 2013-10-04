Template.body.rendered = ->
  hammer = $('body').hammer
    stop_browser_behavior:
      userSelect: false
  hammer.on 'swiperight', ->
    history.back()

  unless window._gaq?
    window._gaq = []
    _gaq.push(['_setAccount', 'UA-15976986-13'])
    _gaq.push(['_trackPageview'])
    (->
      ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true
      gajs = '.google-analytics.com/ga.js'
      ga.src = if 'https:' is document.location.protocol then 'https://ssl'+gajs else 'http://www'+gajs
      s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s)
    )()
