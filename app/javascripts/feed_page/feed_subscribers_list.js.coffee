CommonPlace.pages.PageSubscribersList = CommonPlace.View.extend
  template: "feed_page.subscribers"

  initialize: (options) ->
    @feed = options.feed

  afterRender: () ->
    @feed.subscribers.fetch
      success: (subscribers) =>
        subscribers.each (s) =>
          subscriber = s.toJSON()
          if subscriber.about isnt null
            subscriber.about.trim()
          html = this.renderTemplate("feed_page.subscriber", subscriber)
          this.$(".list").append html

