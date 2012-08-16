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
    resourceNav = new CommonPlace.pages.PageNavView(
      model: feed
      switchTab: (tab) ->
        resource.switchTab tab
    )
    actions = new CommonPlace.pages.PageActionsView(
      feed: feed
      groups: @groups
      account: self.account
      community: self.community
    )
    
    sidebar = new CommonPlace.shared.Sidebar()

    @subViews = [resourceNav, actions, adminBar, sidebar, wire]

  afterRender: ->
    self = this
    _(@subViews).each (view) ->
      view.render()
      self.$("#" + view.id).replaceWith view.el


  isOwner: ->
    @account.isFeedOwner @model
)
