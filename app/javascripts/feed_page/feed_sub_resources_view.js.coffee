CommonPlace.pages.PageSubResourcesView = CommonPlace.View.extend(
  template: "feed_page/feed-subresources"
  id: "feed-subresources"
  initialize: (options) ->
    @account = options.account
    @feed = options.feed
    @announcementsCollection = @feed.announcements
    @eventsCollection = @feed.events
    @subscribersCollection = @feed.subscribers
    @currentTab = options.current or "showAnnouncements"
    @feed.events.on "sync", (->
      @switchTab "showEvents"
    ), this
    @feed.announcements.on "sync", (->
      @switchTab "showAnnouncements"
    ), this
    @feed.subscribers.on "sync", (->
      @switchTab "showSubscribers"
    ), this

  afterRender: ->
    this[@currentTab]()

  showAnnouncements: ->
    account = @account
    wireView = new Wire(
      collection: @announcementsCollection
      account: @account
      el: @$(".feed-announcements .wire")
      emptyMessage: "No announcements here yet"
    )
    wireView.render()

  showEvents: ->
    account = @account
    wireView = new Wire(
      collection: @eventsCollection
      account: @account
      el: @$(".feed-events .wire")
      emptyMessage: "No events here yet"
    )
    wireView.render()

  showSubscribers: ->
    account = @account
    wireView = new Wire(
      collection: @subscribersCollection
      account: @account
      el: @$(".feed-subscribers .wire")
      emptyMessage: "No subscribers yet"
    )
    wireView.render()

  tabs: ->
    showAnnouncements: @$(".feed-announcements")
    showEvents: @$(".feed-events")
    showSubscribers: @$(".feed-subscribers")

  classIfCurrent: ->
    self = this
    (text) ->
      (if text is self.currentTab then "current" else "")

  switchTab: (newTab) ->
    @tabs()[@currentTab].hide()
    @currentTab = newTab
    @tabs()[@currentTab].show()
    @render()

  feedName: ->
    @feed.get "name"
)
