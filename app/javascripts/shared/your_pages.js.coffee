CommonPlace.shared.YourPages = CommonPlace.View.extend
  template: "shared.sidebar.your-pages"
  id      : "your-pages-links"

  afterRender: (params) ->
    self = this
    self.feed_subscriptions = CommonPlace.account.get("feed_subscriptions")
    CommonPlace.community.feeds.fetch
      success: (data) =>
        this.addPageLinks(page, self.feed_subscriptions, false) for page in data.models

    self.group_subscriptions = CommonPlace.account.get("group_subscriptions")
    CommonPlace.community.groups.fetch
      success: (data) =>
        this.addPageLinks(page, self.group_subscriptions, true) for page in data.models

  addPageLinks: (data, subscriptions, subscriptions_only) ->
    page = data.toJSON()
    page.about.trim()
    page.url = "/" + CommonPlace.community.get("slug") + page.url
    html = this.renderTemplate("shared.sidebar.page", page)
    if page.id in subscriptions
      this.$('#your-pages-list').prepend html
    else if not subscriptions_only
      this.$('#your-pages-list').append html
