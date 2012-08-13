CommonPlace.main.CommunityResources = CommonPlace.View.extend(
  template: "main_page.community-resources"
  id: "community-resources"
  events:
    "submit .sticky form": "search"
    "keyup .sticky input": "debounceSearch"
    "click .sticky .cancel": "cancelSearch"
    mouseenter: "showProfile"
    "mouseenter .post": "showProfile"
    "mouseenter .thank-share": "showProfile"

  afterRender: ->
    self = this
    @searchForm = new @SearchForm()
    @searchForm.render()
    $(@searchForm.el).prependTo @$(".sticky")
    $(window).on "scroll.communityLayout", ->
      self.stickHeader true

    @$("[placeholder]").placeholder()

  switchTab: (tab, single) ->
    self = this
    @$(".tab-button").removeClass "current"
    @$("." + tab).addClass "current"
    @view = @tabs[tab](this)
    @$(".search-switch").removeClass "active"
    if _.include(["users", "groups", "feeds"], tab)
      @$(".directory-search").addClass "active"
    else
      @$(".post-search").addClass "active"
    @view.singleWire single  if single
    (if (self.currentQuery) then self.search() else self.showTab())

  winnowToCollection: (collection_name) ->
    self = this
    @view = @tabs[collection_name](this)
    @$(".search-switch").removeClass "active"
    @$(".post-search").addClass "active"  if _.include([], collection_name)
    (if (self.currentQuery) then self.search() else self.showTab())

  showTab: ->
    @$(".resources").empty()
    @$(".resources").append @loading()
    self = this
    @view.resources (wire) ->
      wire.render()
      $(wire.el).appendTo self.$(".resources")

    @stickHeader true

  tabs:
    all_posts: (self) ->
      new DynamicLandingResources(
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )

    posts: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.posts
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
        isInAllWire: false
      )
      self.makeTab wire

    neighborhood: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["neighborhood"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    help: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["help"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    offers: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["offers"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    publicity: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["publicity"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    meetup: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["meetups"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    other: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.categories["other"]
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    events: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.event-resources"
        emptyMessage: "No events here yet."
        collection: CommonPlace.community.events
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    announcements: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.announcement-resources"
        emptyMessage: "No announcements here yet."
        collection: CommonPlace.community.announcements
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    group_posts: (self) ->
      wire = new self.PostLikeWire(
        template: "main_page.group-post-resources"
        emptyMessage: "No posts here yet."
        collection: CommonPlace.community.groupPosts
        callback: ->
          self.stickHeader()

        showProfile: self.options.showProfile
      )
      self.makeTab wire

    groups: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No groups here yet."
        collection: CommonPlace.community.groups
        callback: ->
          self.stickHeader()

        active: "groups"
        showProfile: self.options.showProfile
      )
      self.makeTab wire

    feeds: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No feeds here yet."
        collection: CommonPlace.community.feeds
        callback: ->
          self.stickHeader()

        active: "feeds"
        showProfile: self.options.showProfile
      )
      self.makeTab wire

    users: (self) ->
      wire = new self.GroupLikeWire(
        template: "main_page.directory-resources"
        emptyMessage: "No users here yet."
        collection: CommonPlace.community.users
        callback: ->
          self.stickHeader()

        active: "users"
        showProfile: self.options.showProfile
      )
      self.makeTab wire

  showPost: (post) ->
    self = this
    post.fetch success: ->
      self.showSingleItem post, Posts,
        template: "main_page.post-resources"
        fullWireLink: "#/posts"
        tab: "posts"



  showAnnouncement: (announcement) ->
    self = this
    announcement.fetch success: ->
      self.showSingleItem announcement, Announcements,
        template: "main_page.announcement-resources"
        fullWireLink: "#/announcements"
        tab: "announcements"



  showEvent: (event) ->
    self = this
    event.fetch success: ->
      self.showSingleItem event, Events,
        template: "main_page.event-resources"
        fullWireLink: "#/events"
        tab: "events"



  showGroupPost: (post) ->
    self = this
    post.fetch success: ->
      self.showSingleItem post, GroupPosts,
        template: "main_page.group-post-resources"
        fullWireLink: "#/groupPosts"
        tab: "group_posts"



  highlightSingleUser: (user) ->
    @singleUser = user

  showSingleItem: (model, kind, options) ->
    @model = model
    @isSingle = true
    self = this
    wire = new LandingPreview(
      template: options.template
      collection: new kind([model],
        uri: model.link("self")
      )
      fullWireLink: options.fullWireLink
      callback: ->
        self.stickHeader()
    )
    unless _.isEmpty(@singleUser)
      wire.searchUser @singleUser
      @singleUser = {}
    @switchTab options.tab, wire
    $(window).scrollTo 0

  showProfile: (e) ->
    if @isSingle
      user = new User(links:
        self: @model.link("author")
      )
      @options.showProfile user

  showUserWire: (user) ->
    self = this
    user.fetch success: ->
      collection = new PostLikes([],
        uri: user.link("postlikes")
      )
      wire = new Wire(
        template: "main_page.user-wire-resources"
        collection: collection
        emptyMessage: "No posts here yet."
        callback: ->
          self.stickHeader()
      )
      wire.searchUser user
      self.switchTab "posts", wire
      $(window).scrollTo 0


  debounceSearch: _.debounce(->
    @search()
  , CommonPlace.autoActionTimeout)
  search: (event) ->
    event.preventDefault()  if event
    @currentQuery = @$(".sticky form .search-switch.active input").val()
    if @currentQuery
      @view.search @currentQuery
      @showTab()
      $(".sticky form.search input").addClass "active"
      $(".sticky .cancel").show()
      $(".sticky .cancel").addClass "waiting"
    else
      @cancelSearch()

  cancelSearch: (e) ->
    @currentQuery = ""
    @$(".sticky form.search input").val ""
    @view.cancelSearch()
    @showTab()
    $(".sticky form.search input").removeClass "active"
    $(".sticky .cancel").hide()
    $(".resources").removeHighlight()

  stickHeader: (isFirst) ->
    $sticky_header = @$(".sticky .header")
    sticky_bottom = $sticky_header.offset().top + $sticky_header.outerHeight()
    @$(".resources .loading-resource").remove()  unless isFirst
    current_subnav = @$(".resources .sub-navigation").filter(->
      unless $sticky_header.height()
        $(this).offset().top <= $sticky_header.offset().top
      else
        $nav_text = $(this).children("h2")
        nav_text_bottom = $nav_text.offset().top + $nav_text.height()
        nav_text_bottom <= sticky_bottom
    ).last()
    $sticky_header.html current_subnav.clone()
    $(".sticky .cancel").removeClass "waiting"  if @currentQuery
    CommonPlace.layout.reset()

  makeTab: (wire) ->
    new @ResourceTab(wire: wire)

  loading: ->
    view = new @LoadingResource()
    view.render()
    view.el

  PostLikeWire: Wire.extend(_defaultPerPage: 15)
  GroupLikeWire: Wire.extend(_defaultPerPage: 50)
  ResourceTab: CommonPlace.View.extend(
    initialize: (options) ->
      @wire = options.wire

    resources: (callback) ->
      (if (@single) then callback(@single) else callback(@wire))

    search: (query) ->
      @single = null  if @single
      @wire.search query

    singleWire: (wire) ->
      @single = wire

    cancelSearch: ->
      @search ""
  )
  SearchForm: CommonPlace.View.extend(
    template: "main_page.community-search-form"
    tagName: "form"
    className: "search"
  )
  LoadingResource: CommonPlace.View.extend(
    template: "main_page.loading-resource"
    className: "loading-resource"
  )
)
