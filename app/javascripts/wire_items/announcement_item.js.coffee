CommonPlace.wire_item.AnnouncementWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/announcement-item"
  tagName: "li"
  className: "wire-item"
  initialize: (options) ->
    self = this
    @model.on "destroy", ->
      self.remove()

    @in_reply_state = true

  afterRender: ->
    @model.on "change", @render, this
    @repliesView = {}
    @reply()
    @$(".announcement-body").truncate max_length: 450
    @checkThanked()
    @$(".ts-text").hide()  if @numThanks() is 0

  publishedAt: ->
    timeAgoInWords @model.get("published_at")

  avatarUrl: ->
    @model.get "avatar_url"

  title: ->
    @model.get "title"

  author: ->
    @model.get "author"

  first_name: ->
    @model.get "first_name"

  body: ->
    @model.get "body"

  numThanks: ->
    @directThanks().length

  peoplePerson: ->
    (if (@model.get("thanks").length is 1) then "person" else "people")

  events:
    "click .editlink": "editAnnouncement"
    mouseenter: "showProfile"
    "mouseenter .announcement": "showProfile"
    "click .announcement > .author": "messageUser"
    "click .thank-link": "thank"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"
    "click .ts-text": "showThanks"

  editAnnouncement: (e) ->
    e.preventDefault()  if e
    formview = new PostFormView(
      model: @model
      template: "shared/announcement-edit-form"
    )
    formview.render()

  canEdit: ->
    CommonPlace.account.canEditAnnouncement @model

  isMore: ->
    not @allwords

  loadMore: (e) ->
    e.preventDefault()
    @allwords = true
    @render()

  showProfile: (e) ->
    @options.showProfile @model.author()

  isFeed: ->
    @model.get("owner_type") is "Feed"

  feedUrl: ->
    @model.get "feed_url"

  messageUser: (e) ->
    unless @isFeed()
      e.preventDefault()  if e
      user = new User(links:
        self: @model.get("user_url")
      )
      user.fetch success: ->
        formview = new MessageFormView(model: new Message(messagable: user))
        formview.render()
)
