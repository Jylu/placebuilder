CommonPlace.main.YourPages = CommonPlace.View.extend
  template: "main_page.sidebar.your-pages"

  afterRender: (params) -> 
    self = this
    self.subscriptions = CommonPlace.account.get("feed_subscriptions")
    CommonPlace.community.feeds.fetch
      success: (data) =>
        this.addFeedPageLinks(page, self.subscriptions) for page in data.models

  addFeedPageLinks: (data, subscriptions) ->
    page = data.toJSON()
    page.url = "/"+CommonPlace.community.get("slug")+page.url
    page.about.trim()
    html = this.renderTemplate("main_page.sidebar.page", page)
    if page.id in subscriptions
      this.$('#your-pages-list').prepend html
    else
      this.$('#your-pages-list').append html
