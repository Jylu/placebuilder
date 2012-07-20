$ ->

  slug = window.location.pathname.split("/")[1]

  $("body").delegate "a[data-remote]", "click", (e) ->
    e.preventDefault()
    path = e.currentTarget.pathname
    Backbone.history.navigate path, true

  window.router = new Home.Router();

  account = new Home.model.Account

  e = document.createElement('script')
  e.src = document.location.protocol + '//connect.facebook.net/en_US/all.js'
  e.async = true
  fb_root = document.getElementById('fb-root')
  fb_root.appendChild(e)

  (new Home.model.Community(slug: slug)).fetch
    success: (community) ->

      router.community = community

      (new Home.model.Account).fetch

        success: (account) ->

          _kmq.push(['identify', account.get('email')]);
          _kmq.push(['record', 'main page']);

          router.account = account

          Backbone.history.start(pushState: true)

        error: ->
          router.register(slug)

    error: ->
      alert "we couldn't load the community"



