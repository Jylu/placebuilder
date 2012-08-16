CommonPlace.pages.PageRouter = Backbone.Router.extend(
  routes:
    "/feeds/:slug": "show"
    "/pages/:slug": "show"

  initialize: (options) ->
    self = this
    @account = options.account
    @community = options.community
    CommonPlace.pages.feeds = options.feeds
    @show options.feed

  show: (slug) ->
    self = this
    header = new CommonPlace.shared.HeaderView()
    header.render()
    $("#header").replaceWith header.el

    $.getJSON "/api" + @community.links.groups, (groups) ->
      $.getJSON "/api/feeds/" + slug, (response) ->
        feed = new Feed(response)
        document.title = feed.get("name")
        pageView = new CommonPlace.pages.PageView(
          model: feed
          community: self.community
          account: self.account
          groups: groups
        )
        window.currentPageView = pageView
        pageView.render()
        $("#feed").replaceWith pageView.el

)
