CommonPlace.wire_item.ReplyWireItem = CommonPlace.wire_item.WireItem.extend(
  tagName: "li"
  className: "reply-item"
  template: "wire_items/reply-item"
  initialize: (options) ->
    @model.on "destroy", @remove, this

  afterRender: ->
    @$(".reply-body").truncate max_length: 450
    @$(".markdown p").last().append @$(".controls")

  events:
    "click .reply-text > .author": "messageUser"
    mouseenter: "showProfile"
    "click .delete-reply": "deleteReply"
    "click .thank-reply": "thankReply"
    "click .thanks_count": "showThanks"

  time: ->
    timeAgoInWords @model.get("published_at")

  author: ->
    @model.get "author"

  first_name: ->
    @author().split(" ")[0]

  authorAvatarUrl: ->
    @model.get "avatar_url"

  body: ->
    @model.get "body"

  messageUser: (e) ->
    e.preventDefault()  if e
    unless @model.get("author_id") is CommonPlace.account.id
      @model.user (user) ->
        formview = new MessageFormView(model: new Message(messagable: user))
        formview.render()

  showProfile: (e) ->
    user = new User(links:
      self: @model.link("author")
    )
    @options.showProfile user

  canEdit: ->
    CommonPlace.account.canEditReply @model

  deleteReply: (e) ->
    e.preventDefault()
    self = this
    @model.destroy()

  numThanks: ->
    @model.get("thanks").length

  hasThanks: ->
    @numThanks() > 0

  peoplePerson: ->
    (if (@numThanks() is 1) then "person" else "people")

  hasThanked: ->
    _.any @model.get("thanks"), (thank) ->
      thank.thanker is CommonPlace.account.get("name")

  canThank: ->
    @model.get("author_id") isnt CommonPlace.account.id

  thankReply: (e) ->
    e.preventDefault()  if e
    $.post "/api" + @model.link("thank"), @options.thankReply

  showThanks: (e) ->
    e.preventDefault()  if e
    @options.showThanks()
)
