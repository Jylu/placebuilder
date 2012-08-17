CommonPlace.pages.PageView = CommonPlace.View.extend(
  template: "feed_page/feed"
  id: "feed"
  initialize: (options) ->
    self = this
    @community = options.community
    @account = options.account
    @groups = options.groups
    feed = @model
    resourceNav = undefined
    resource = undefined
    actions = undefined
    profile = undefined
    about = undefined
    header = undefined
    feedAdminBar = undefined
    sidebar = undefined

    adminBar = new CommonPlace.pages.PageAdminBar(
      model: feed
      collection: @account.feeds
      account: @account
    )
    profile = new CommonPlace.pages.PageProfileView(
      model: feed
      account: @account
    )
    about = new CommonPlace.pages.PageAboutView(model: feed)
    wire = new CommonPlace.pages.PageSubResourcesView(
      feed: feed
      account: self.account
    )
    wireNav = new CommonPlace.pages.PageNavView(
      model: feed
      switchTab: (tab) ->
        wire.switchTab tab
    )
    actions = new CommonPlace.pages.PageActionsView(
      feed: feed
      groups: @groups
      account: self.account
      community: self.community
    )
    
    sidebar = new CommonPlace.shared.Sidebar(
      tabs: [{
        title: "subscribers"
        text: "Subscribers"
      }, {
        title: "similar"
        text: "Similar"
      }]
      tabviews:
        subscribers: new CommonPlace.pages.PageSubscribersList(feed: @model)
        similar: new CommonPlace.pages.PageListView()
      nav: wireNav
      avatar_url: feed.get("avatar_url")
    )

    @subViews = [actions, adminBar, sidebar, wire]

  afterRender: ->
    self = this
    _(@subViews).each (view) ->
      view.render()
      self.$("#" + view.id).replaceWith view.el


  isOwner: ->
    @account.isFeedOwner @model
)
