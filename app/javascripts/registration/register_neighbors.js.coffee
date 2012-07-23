CommonPlace.registration.NeighborsView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.neighbors"
  is_callback: false
  callback_token: `undefined`
  callback_verifier: `undefined`
  ConsentToken: `undefined`
  exp: `undefined`
  lid: `undefined`
  delt: `undefined`
  events:
    "click input.continue": "submit"
    "click img.facebook": "facebook"
    "click img.google": "gmail"
    "click img.yahoo": "yahoo"
    "click img.windows_live": "windows_live"
    "click li.add .addb": "addNeighbor"
    "click input.contact": "toggleContact"
    "keyup form.list input.search": "debounceSearch"
    "click form.list .remove_search.active": "removeSearch"
    "submit form.list": "submit"

  email_address_contains: (email, string) ->
    email and (email.indexOf(string) isnt -1)

  is_google_user: (email_address) ->
    @email_address_contains(email_address, "@gmail") or @email_address_contains(email_address, "@google")

  is_yahoo_user: (email_address) ->
    @email_address_contains email_address, "@yahoo"

  is_windows_live_user: (email_address) ->
    @email_address_contains(email_address, "@hotmail") or @email_address_contains(email_address, "@live")

  afterRender: ->
    self = this
    if @is_google_user(@options.data.email)
      GoogleContacts.prepare success: _.bind((friends) ->
        @friends = friends
        @gmail_connected = true
        @generate false
      , this)
      @$("img.google").show()
    else if @is_yahoo_user(@options.data.email)
      YahooContacts.prepare success: _.bind((friends) ->
        @friends = friends
        @yahoo_connected = true
        @generate false
      , this)
      @$("img.yahoo").show()
    else if @is_windows_live_user(@options.data.email)
      WindowsLiveContacts.prepare success: _.bind((friends) ->
        @friends = friends
        @windows_live_connected = true
        @generate false
      , this)
      @$("img.windows_live").show()
    @currentQuery = ""
    @$(".no_results").hide()
    @$(".search_finder").hide()
    @$(".initial_load").show()
    @$("form.add").hide()
    @$("form.add .error").hide()
    @$(".neighbor_finder").scroll ->
      self.nextPageThrottled()  if ($(this).scrollTop() + 30) > (5 * @scrollHeight / 7)

    @nextPageTrigger()
    @slideIn @el, _.bind(->
      $.getJSON "/api" + @communityExterior.links.registration.residents,
        limit: 3000
      , _.bind((response) ->
        if response.length
          @neighbors = response
          @generate @options.data.isFacebook
      , this)
    , this)

  nextPageTrigger: ->
    @nextPageThrottled = _.once(_.bind(->
      @nextNeighborsPage()
    , this))

  generate: (checkExternalService) ->
    if checkExternalService is "facebook"
      facebook_connect_friends success: _.bind((friends) ->
        @friends = friends
        @facebook_connected = true
        @generate false
      , this)
    else if checkExternalService is "gmail"
      GoogleContacts.retrievePairedContacts()
    else if @is_callback
      unless @callback_verifier is `undefined`
        YahooContacts.retrievePairedContacts @callback_verifier
      else
        WindowsLiveContacts.retrievePairedContacts @ConsentToken, @exp, @lid, @delt
      @is_callback = false
    else
      @items = []
      @limit = 0
      @neighbors = _.sortBy(@neighbors, (neighbor) ->
        neighbor.last_name
      )
      _.each @neighbors, _.bind((neighbor) ->
        itemView = @generateItem(neighbor, false)
        if itemView.isFacebook() or itemView.isGmail()
          @items.unshift itemView
          @limit++
        else
          @items.push itemView
      , this)
      @limit += 100
      @$(".neighbor_finder table").empty()
      @$(".initial_load").hide()
      @nextPageThrottled()

  generateItem: (neighbor, isSearch) ->
    intersectedUser = @getIntersectedUser(neighbor)
    addFromSearch = undefined
    if isSearch
      addFromSearch = _.bind((el) ->
        @appendCell @$(".neighbor_finder table"), el
        @removeSearch()
        @$(".neighbor_finder").scrollTo el
      , this)
    else
      addFromSearch = ->
    intersectionType = ""
    intersectionType = "facebook"  if @facebook_connected
    intersectionType = "gmail"  if @gmail_connected
    intersectionType = "yahoo"  if @yahoo_connected
    intersectionType = "windows_live"  if @windows_live_connected
    itemView = new @NeighborItemView(
      model: neighbor
      intersectedUser: intersectedUser
      intersectionType: intersectionType
      search: isSearch
      showCount: _.bind(->
        @showCount()
      , this)
      addFromSearch: addFromSearch
    )
    itemView

  nextNeighborsPage: ->
    return  if _.isEmpty(@items)
    @showGif "loading"
    currentItems = _.first(@items, @limit)
    @items = _.rest(@items, @limit)
    _.each currentItems, _.bind((itemView) ->
      itemView.render()
      @appendCell @$(".neighbor_finder table"), itemView.el
    , this)
    @nextPageTrigger()
    @showGif "inactive"

  appendCell: ($table, el) ->
    $row = undefined
    $lastRow = $(_.last($table[0].rows))
    if $table[0].rows.length and $lastRow[0].cells.length is 1
      $row = $lastRow
    else
      $row = $($table[0].insertRow(-1))
    $row.append el

  facebook: (e) ->
    e.preventDefault()  if e
    @generate "facebook"

  gmail: (e) ->
    e.preventDefault()  if e
    @generate "gmail"

  yahoo: (e) ->
    e.preventDefault()  if e
    $.ajax
      type: "POST"
      contentType: "application/json"
      url: "/api/contacts/authorization_url/yahoo"
      data: JSON.stringify(return_url: "" + CommonPlace.community.link("base") + "/" + CommonPlace.community.link("email_contact_authorization_callback"))
      success: (response) ->
        window.location = response

  windows_live: (e) ->
    e.preventDefault()  if e
    $.ajax
      type: "POST"
      contentType: "application/json"
      url: "/api/contacts/authorization_url/windows_live"
      data: JSON.stringify(return_url: "" + CommonPlace.community.link("base") + "/" + CommonPlace.community.link("email_contact_authorization_callback"))
      success: (response) ->
        window.location = response

  getIntersectedUser: (neighbor) ->
    name = neighbor.first_name + " " + neighbor.last_name
    _.find @friends, (friend) ->
      friend.name.toLowerCase() is name.toLowerCase()

  debounceSearch: _.debounce(->
    @search()
  , CommonPlace.autoActionTimeout)
  search: ->
    @showGif "loading"
    @$(".no_results").hide()
    @currentQuery = @$("input[name=search]").val()
    unless @currentQuery
      @removeSearch()
    else
      @currentScroll = @$(".neighbor_finder").scrollTop()
      @$(".neighbor_finder").hide()
      @$(".search_finder").show()
      @$(".search_finder table").empty()
      @showSearch()

  showSearch: ->
    $.getJSON "/api" + CommonPlace.community.link("residents"),
      limit: 100
      query: @currentQuery
    , _.bind((response) ->
      @showGif "active"
      unless response.length
        @$(".no_results").show()
        @$(".query").text @currentQuery
      else
        results = []
        _.each response, _.bind((neighbor) ->
          itemView = @generateItem(neighbor, true)
          (if (not itemView.isFacebook() or not itemView.isGmail()) then results.unshift(itemView) else results.push(itemView))
        , this)
        _.each results, _.bind((itemView) ->
          itemView.render()
          @appendCell @$(".search_finder table"), itemView.el
        , this)
    , this)

  removeSearch: (e) ->
    e.preventDefault()  if e
    @currentQuery = ""
    @$("input[name=search]").val ""
    @$(".search_finder").hide()
    @$(".neighbor_finder").show()
    @$(".neighbor_finder").scrollTo @currentScroll  unless @$(".neighbor_finder").scrollTop()
    @showGif "inactive"

  toggleContact: (e) ->
    @$("input.contact").removeAttr "checked"
    $(e.currentTarget).attr "checked", "checked"

  showGif: (className) ->
    @$(".remove_search").removeClass "inactive"
    @$(".remove_search").removeClass "active"
    @$(".remove_search").removeClass "loading"
    @$(".remove_search").addClass className

  showCount: ->
    count = @$(".neighbor_finder input[name=neighbors_list]:checked").length
    @$(".neighbor_count").text count
    @$(".neighbor_count_li .plural").text (if count is 1 then "neighbor" else "neighbors")

  toggleAddNeighbor: (e) ->
    e.preventDefault()  if e
    if @$("form.add:visible").length
      @$("form.add").hide()
    else
      @$("form.add").show()
      @$("form.add .error").hide()

  addNeighbor: (e) ->
    e.preventDefault()  if e
    full_name = $(e.target).siblings("input[name=name]").val()
    email = $(e.target).siblings("input[name=email]").val()
    neighbor =
      full_name: full_name
      first_name: _.first(full_name.split(" "))
      last_name: _.last(full_name.split(" "))
      email: email
      avatar_url: `undefined`

    itemView = @generateItem(neighbor, false)
    itemView.render()
    @appendCell @$(".neighbor_finder table"), itemView.el
    itemView.check()
    @$(".neighbor_finder").scrollTo itemView.el
    $(e.target).siblings("input[type=text]").val ""

  NeighborItemView: CommonPlace.View.extend(
    template: "registration.neighbor-item"
    tagName: "td"
    events:
      click: "check"

    initialize: (options) ->
      @_isFacebook = not _.isEmpty(@options.intersectedUser) and @options.intersectionType is "facebook"
      @_isGmail = not _.isEmpty(@options.intersectedUser) and @options.intersectionType is "gmail"
      @_isYahoo = not _.isEmpty(@options.intersectedUser) and @options.intersectionType is "yahoo"
      @_isWindowsLive = not _.isEmpty(@options.intersectedUser) and @options.intersectionType is "windows_live"

    afterRender: ->
      @$(".on-commonplace").hide()  unless @model.on_commonplace
      if @isFacebook()
        @check()  unless @options.search
        facebook_connect_user_picture
          id: @options.intersectedUser.id
          success: _.bind((url) ->
            @$("img").attr "src", url
          , this)
      else @check()  unless @options.search  if @isGmail()

    avatar_url: ->
      if @model.on_commonplace
        @model.avatar_url
      else
        "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"

    first_name: ->
      @model.first_name

    last_name: ->
      @model.last_name

    email: ->
      @model.email

    facebook_id: ->
      @isFacebook() and @options.intersectedUser.id

    isFacebook: ->
      @_isFacebook

    isGmail: ->
      @_isGmail

    isYahoo: ->
      @_isYahoo

    isWindowsLive: ->
      @_isWindowsLive

    check: (e) ->
      e.preventDefault()  if e
      if @options.search
        @options.search = false
        @options.addFromSearch @el
      $checkbox = @$("input[type=checkbox]")
      if $checkbox.attr("checked")
        $checkbox.removeAttr "checked"
      else
        $checkbox.attr "checked", "checked"
      $(@el).toggleClass "checked"
      @options.showCount()
  )
  community_name: ->
    CommonPlace.community.get "name"

  submit: (e) ->
    e.preventDefault()  if e
    @removeSearch()  if @currentQuery
    data =
      neighbors: _.map(@$(".neighbor_finder input[name=neighbors_list]:checked"), (neighbor) ->
        name: $(neighbor).attr("data-name")
        email: $(neighbor).attr("data-email")
      )
      can_contact: (if (@$("input[name=can_contact]").attr("checked")) then true else false)

    if data.can_contact and @facebook_connected
      facebook_neighbors = _.map($(".neighbor_finder input[name=neighbors_list]:checked[data-facebook-id]"), (elm) ->
        $(elm).attr "data-facebook-id"
      )
      community_slug = CommonPlace.community.get("slug")
      community_name = CommonPlace.community.get("name")
      FB.ui
        method: "apprequests"
        message: "I joined The " + community_name + " CommonPlace, a new online community bulletin board for neighbors in " + community_name + ". You should join too at: www." + community_slug + ".OurCommonPlace.com."
        data: community_slug
        to: facebook_neighbors
      , callback
    data.can_contact and (@gmail_connected or @yahoo_connected or @windows_live_connected)
    if data.neighbors.length
      $.ajax
        type: "POST"
        contentType: "application/json"
        url: "/api" + CommonPlace.account.link("neighbors")
        data: JSON.stringify(data)
        success: _.bind(->
          @finish()
        , this)
    else
      @finish()

  getFacebookUser: (name) ->
    _.find @friends, (friend) ->
      friend.name.toLowerCase() is name.toLowerCase()

  finish: ->
    @complete()

)
