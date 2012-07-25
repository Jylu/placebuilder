CommonPlace.main.YourPages = CommonPlace.View.extend
  template: "main_page.sidebar.your-pages"

  afterRender: (params) -> 
    self = this
    self.subscriptions = CommonPlace.account.get("feed_subscriptions")
    CommonPlace.community.feeds.fetch
      success: (data) =>
        this.addFeedPageLink(data, id) for id in self.subscriptions

  addFeedPageLink: (data, id) ->
    p = data._byId[id]
    if p
      page = p.toJSON()
      page.url = "/"+CommonPlace.community.get("slug")+page.url
      page.about.trim()
      html = this.renderTemplate("main_page.sidebar.page", page)
      this.$('#your-pages-list').append html
