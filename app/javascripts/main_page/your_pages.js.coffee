CommonPlace.main.YourPages = CommonPlace.View.extend
  template: "main_page.your-pages"

  afterRender: (params) -> 
    subscriptions = CommonPlace.account.get("feed_subscriptions")
    this.addFeedPageLink(feed_id) for feed_id in subscriptions

  addFeedPageLink: (feed_id) ->
    CommonPlace.community.feeds.fetch
      success: (data) =>
        data.each (p) =>
          page = p.toJSON()
          page.url = "/"+CommonPlace.community.get("slug")+"/"+page.url
          page.about.trim()
          html = this.renderTemplate("main_page.page", page)
          this.$('#your-pages-list').append html
      , feed_id
