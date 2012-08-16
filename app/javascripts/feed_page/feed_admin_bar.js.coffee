CommonPlace.pages.PageAdminBar = CommonPlace.View.extend(
  template: "feed_page/feed-admin-bar"
  id: "feed-admin-bar"
  feeds: ->
    self = this
    feeds = _(@options.account.get("feeds")).map((f) ->
      name: f.name
      slug: f.slug
      current: f.id is self.model.id
    )
    feeds
)
