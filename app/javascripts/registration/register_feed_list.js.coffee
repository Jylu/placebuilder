CommonPlace.registration.FeedListView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.home_feed"
  feed_kinds: [ "Non-profit", "Community Group", "Business", "Municipal", "News", "Other" ]
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    feeds = @communityExterior.feeds
    $ul = @$("ul.feeds_container")
    _.each feeds, _.bind((feed) ->
      itemView = new @FeedItem(model: feed)
      itemView.render()
      category = "#" + @feed_kinds[feed.kind]
      @$(category).append itemView.el
    , this)
    @slideIn @el

  community_name: ->
    @communityExterior.name

  categories: ->
    @feed_kinds

  submit: (e) ->
    e.preventDefault()  if e
    feeds = _.map(@$("input[name=feeds_list]:checked"), (feed) ->
      $(feed).val()
    )
    if _.isEmpty(feeds)
      @finish()
    else
      CommonPlace.account.subscribeToFeed feeds, _.bind(->
        @finish()
      , this)

  finish: ->
    if @communityExterior.has_residents_list
      @nextPage "neighbors", @data
    else
      @complete()

  FeedItem: CommonPlace.View.extend(
    template: "registration.home_feed-item"
    tagName: "li"
    events:
      click: "check"

    initialize: (options) ->
      @model = options.model

    avatar_url: ->
      @model.avatar_url

    feed_id: ->
      @model.id

    feed_name: ->
      @model.name

    feed_about: ->
      @model.about

    check: (e) ->
      e.preventDefault()  if e
      $checkbox = @$("input[type=checkbox]")
      if $checkbox.attr("checked")
        $checkbox.removeAttr "checked"
        @$(".check").removeClass "checked"
      else
        $checkbox.attr "checked", "checked"
        @$(".check").addClass "checked"
  )
)
