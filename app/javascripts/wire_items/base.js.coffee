CommonPlace.wire_item.WireItem = CommonPlace.View.extend(
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
        showProfile: @options.showProfile
      )
      thanksView.render()
      @$(".replies-area").append thanksView.el
      @state = "thanks"

  share: (e) ->
    e.preventDefault()  if e
    @state = "share"
    @removeFocus()
    $("#modal").empty()
    @$(".share-link").addClass "current"
    shareModal = new CommonPlace.view.ShareModal(
      model: @model
      account: CommonPlace.account
      message: "Share this post with more people!"
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
        showProfile: @options.showProfile
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
)
