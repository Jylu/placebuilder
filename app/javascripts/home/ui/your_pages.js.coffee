Home.ui.YourPages = Framework.View.extend
  template: "home.your-pages"

  render: (params) -> 
    account = router.account
    subscriptions = account.get("feed_subscriptions")
    this.addFeedPageLink(feed_id) for feed_id in subscriptions
    
    this.$el.html this.renderTemplate(params)

  addFeedPageLink: (feed_id) ->
    router.community.getPage
      success: (data) =>
        data.each (p) =>
          page = p.toJSON()
          page.url = "home"+page.url
          page.about.trim()
          html = this.renderTemplate("home.page", page)
          this.$('#your-pages-list').append html
      , feed_id
