CommonPlace.shared.YourPages = CommonPlace.View.extend
  template: "shared.sidebar.your-pages"
  id      : "your-pages-links"

  afterRender: (params) -> 
    self = this
    self.subscriptions = CommonPlace.account.get("feed_subscriptions")
    CommonPlace.community.feeds.fetch
      success: (data) =>
        this.addFeedPageLinks(page, self.subscriptions) for page in data.models

  addFeedPageLinks: (data, subscriptions) ->
    page = data.toJSON()
    page.about.trim()
    html = this.renderTemplate("shared.sidebar.page", page)
    if page.id in subscriptions
      this.$('#your-pages-list').prepend html
    else
      this.$('#your-pages-list').append html
