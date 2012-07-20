CommonPlace.wire_item.EventWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/event-item"
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
    @$(".event-body").truncate max_length: 450
    @checkThanked()
    @$(".ts-text").hide()  if @numThanks() is 0

  short_month_name: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    @monthAbbrevs[m[2] - 1]

  day_of_month: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    m[3]

  publishedAt: ->
    timeAgoInWords @model.get("published_at")

  title: ->
    @model.get "title"

  author: ->
    @model.get "author"

  first_name: ->
    @model.get "first_name"

  venue: ->
    @model.get "venue"

  address: ->
    @model.get "address"

  time: ->
    @model.get "starts_at"

  body: ->
    @model.get "body"

  numThanks: ->
    @directThanks().length

  peoplePerson: ->
    (if (@model.get("thanks").length is 1) then "person" else "people")

  monthAbbrevs: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ]
  events:
    "click .editlink": "editEvent"
    mouseenter: "showProfile"
    "mouseenter .event": "showProfile"
    "click .event > .author": "messageUser"
    "click .thank-link": "thank"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"
    "click .ts-text": "showThanks"

  editEvent: (e) ->
    e and e.preventDefault()
    formview = new EventFormView(
      model: @model
      template: "shared/event-edit-form"
    )
    formview.render()

  canEdit: ->
    CommonPlace.account.canEditEvent @model

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
      e and e.preventDefault()
      user = new User(links:
        self: @model.get("user_url")
      )
      user.fetch success: ->
        formview = new MessageFormView(model: new Message(messagable: user))
        formview.render()
)
