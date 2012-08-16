CommonPlace.pages.PageHeaderView = CommonPlace.View.extend(
  template: "feed_page/feed-header"
  id: "feed-header"
  initialize: (options) ->
    @account = options.account

  events:
    "click a.subscribe": "subscribe"
    "click a.unsubscribe": "unsubscribe"
    "click .feed-edit": "openEditModal"

  isSubscribed: ->
    @account.isSubscribedToFeed @model

  isOwner: ->
    @account.isFeedOwner @model

  editURL: ->
    @model.link "edit"

  subscribe: (e) ->
    self = this
    e.preventDefault()
    @account.subscribeToFeed @model, ->
      self.render()


  unsubscribe: (e) ->
    self = this
    e.preventDefault()
    @account.unsubscribeFromFeed @model, ->
      self.render()


  feedName: ->
    @model.get "name"

  openEditModal: (e) ->
    e.preventDefault()
    formview = new FeedEditFormView(model: @model)
    formview.render()
)
