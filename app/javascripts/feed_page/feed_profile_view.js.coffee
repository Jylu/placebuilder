CommonPlace.pages.PageProfileView = CommonPlace.View.extend(
  template: "feed_page/feed-profile"
  id: "feed-profile"
  initialize: (options) ->
    @account = options.account

  events:
    "click .send-message": "openMessageModal"
    "click .feed-owners": "openPermissionsModal"

  openMessageModal: (e) ->
    e.preventDefault()
    formview = new MessageFormView(model: new Message(messagable: @model))
    formview.render()

  openPermissionsModal: (e) ->
    e.preventDefault()
    formview = new FeedOwnersFormView(model: @model)
    formview.render()

  avatarSrc: ->
    @model.get("links").avatar.large

  address: ->
    @model.get "address"

  phone: ->
    @model.get "phone"

  website: ->
    return false  unless @model.get("website")
    if @model.get("website").length <= 35
      @model.get "website"
    else
      @model.get("website").substring(0, 32) + "..."

  websiteURL: ->
    @model.get "website"

  isOwner: ->
    @account.isFeedOwner @model
)
