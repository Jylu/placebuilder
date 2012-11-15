CommonPlace.wire_item.WireItem = CommonPlace.View.extend(

  initialize: (options) ->
    self = this
    @model.on "destroy", ->
      self.remove()

  afterRender: ->
    @model.on "change", @render, this
    @reply() if @model.get("replies") isnt undefined
    @checkThanked()
    @checkFlagged()

  checkThanked: ->
    if @thanked()
      @$(".thank-link").html "Thanked!"
      @$(".thank-link").addClass "thanked-post"

  thanked: ->
    thanks = _.map(@directThanks(), (thank) ->
      thank.thanker
    )
    _.include thanks, CommonPlace.account.get("name")

  directThanks: ->
    _.filter @model.get("thanks"), (t) ->
      t.thankable_type isnt "Reply"

  thank: ->
    @$(".thank-share .current").removeClass "current"
    return @showThanks()  if @thanked()
    $.post "/api" + @model.link("thank"), _.bind((response) ->
      @model.set response
      @render()
      @showThanks()
    , this)

  showThanks: (e) ->
    e.preventDefault()  if e
    unless _.isEmpty(@model.get("thanks"))
      @removeFocus()
      @$(".thank-link").addClass "current"
      @$(".replies-area").empty()
      thanksView = new ThanksListView(
        model: @model
      )
      thanksView.render()
      @$(".replies-area").append thanksView.el
      @state = "thanks"

  checkFlagged: ->
    if @flagged()
      @$(".flag-link").html "Flagged!"
      @$(".flag-link").addClass "flagged-post"

  flagged: ->
    flags = _.map(@directFlags(), (flag) ->
      flag.warner
    )
    _.include flags, CommonPlace.account.get("name")

  directFlags: ->
    _.filter @model.get("flags"), (t) ->
      t.warnable_type isnt "Reply"

  flag: ->
    return @showFlags() if @flagged()
    $.post "/api" + @model.link("flag"), _.bind((response) ->
      @model.set response
      @render()
    , this)

  showFlags: (e) ->
    e.preventDefault()  if e
    unless _.isEmpty(@model.get("flags"))
      @removeFocus()
      @$(".flag-link").addClass "current"
      @state = "thanks"

  share: (e) ->
    e.preventDefault()  if e
    @state = "share"
    @removeFocus()
    $("#modal").empty()
    @$(".share-link").addClass "current"
    shareModal = new CommonPlace.views.ShareModal(
      model: @model
      account: CommonPlace.account
      message: ""
      header: "Share this post!"
    )
    shareModal.render()
    $("#modal").append shareModal.el

  reply: (e) ->
    e.preventDefault()  if e
    isFirst = _.isEmpty(@repliesView)
    if @state isnt "reply" or isFirst
      @removeFocus()
      @$(".reply-link").addClass "current"
      @$(".replies-area").empty()
      @repliesView = new RepliesView(
        collection: @model.replies()
        thankReply: _.bind((response) ->
          @model.set response
        , this)
        showThanks: _.bind(->
          @showThanks()
        , this)
      )
      @repliesView.collection.on "change", _.bind(->
        @render()
      , this)
      @repliesView.render()
      @$(".replies-area").append @repliesView.el
    unless isFirst
      @$(".reply-text-entry").focus()
      @state = "reply"

  removeFocus: ->
    @$(".thank-share .current").removeClass "current"

  publishedAt: ->
    timeAgoInWords @model.get("published_at")

  publishedAtISO: ->
    @model.get "published_at"

  avatarUrl: ->
    @model.get "avatar_url"

  messageUrl: ->
    "/" + CommonPlace.community.get("slug") + "/message" + @model.get("author_url")

  hasImages: ->
    if @model.get("images").length > 0
      return true
    else
      return false

  images: ->
    @model.get "images"

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

  wireCategory: ->
    @model.get "category"

  wireCategoryName: ->
    category = @wireCategory()
    if category
      category = (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
    else
      category = "Post"

  isFeed: ->
    @model.get("owner_type") is "Feed"

  feedUrl: ->
    @model.get "feed_url"
)
