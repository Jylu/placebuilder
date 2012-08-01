CommonPlace.registration.Router = Backbone.Router.extend(
  routes:
    "": "new_user"
    "/": "new_user"
    "new": "new_user"
    "register/profile": "profile"
    "register/avatar": "crop"
    "register/crop": "crop"
    "register/feeds": "feed"
    "register/groups": "group"
    "register/neighbors": "neighbors"
    "*p": "new_user"

  initialize: (options) ->
    @initFacebook()
    header = new CommonPlace.shared.HeaderView(el: $("#header"))
    header.render()
    @modal = new CommonPlace.registration.RegistrationModal(
      communityExterior: options.communityExterior
      template: "registration.modal"
      complete: ->
        window.location.pathname = options.communityExterior.links.tour

      el: $("#registration-modal")
    )
    @modal.render()

  new_user: ->
    @modal.showPage "new_user"

  address: ->
    @modal.showPage "address"

  welcome: ->
    @modal.showPage "welcome"

  profile: ->
    @modal.showPage "profile"

  crop: ->
    @modal.showPage "crop"

  feed: ->
    @modal.showPage "feed"

  group: ->
    @modal.showPage "group"

  neighbors: ->
    @modal.showPage "neighbors", CommonPlace.account.toJSON()

  initFacebook: ->
    e = document.createElement("script")
    e.src = document.location.protocol + "//connect.facebook.net/en_US/all.js"
    e.async = true
    document.getElementById("fb-root").appendChild e
)

CommonPlace.registration.RegistrationModal = CommonPlace.View.extend(
  id: "registration-modal"
  events:
    "click #modal-whiteout": "exit"

  afterRender: ->
    @communityExterior = @options.communityExterior
    @firstSlide = true

  showPage: (page, data) ->
    self = this
    nextPage = (next, data) ->
      self.showPage next, data

    slideIn = (el, callback) ->
      self.slideIn el, callback

    @slideOut()  unless @firstSlide
    view = {
      new_user: ->
        new CommonPlace.registration.NewUserView(
          nextPage: nextPage
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
        )

      address: ->
        new CommonPlace.registration.AddressView(
          nextPage: nextPage
          data: data
          slideIn: slideIn
          communityExterior: self.communityExterior
          complete: self.options.complete
        )

      welcome: ->
        new CommonPlace.registration.WelcomeView(
          nextPage: nextPage
          data: data
          slideIn: slideIn
          communityExterior: self.communityExterior
        )

      profile: ->
        new CommonPlace.registration.ProfileView(
          nextPage: nextPage
          data: data
          slideIn: slideIn
          communityExterior: self.communityExterior
        )

      crop: ->
        new CommonPlace.registration.CropView(
          nextPage: nextPage
          slideIn: slideIn
          data: data
        )

      feed: ->
        new CommonPlace.registration.FeedListView(
          nextPage: nextPage
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
          complete: self.options.complete
        )

      group: ->
        new CommonPlace.registration.GroupListView(
          nextPage: nextPage
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
          complete: self.options.complete
        )

      neighbors: ->
        new CommonPlace.registration.NeighborsView(
          complete: self.options.complete
          slideIn: slideIn
          communityExterior: self.communityExterior
          data: data
          nextPage: nextPage
        )
    }[page]()
    view.render()

  centerEl: ->
    $el = @$("#current-registration-page")
    $el.css @dimensions($el)

  slideOut: ->
    $current = @$("#current-registration-page")
    dimensions = @dimensions($current)
    @slide $current,
      left: 0 - $current.width()
    , ->
      $current.empty()
      $current.hide()

  slideIn: (el, callback) ->
    $next = @$("#next-registration-page")
    $window = $(window)
    $current = @$("#current-registration-page")
    $pagewidth = @$("#pagewidth")
    $pagewidth.css top: $(@el).offset().top
    $next.show()
    $next.append el
    dimensions = @dimensions($next)
    $next.css left: $window.width()
    @slide $next,
      left: dimensions.left
    , _.bind(->
      $current.html $next.children("div").detach()
      $current.show()
      @centerEl()
      $next.empty()
      $next.hide()
      callback()  if callback
    , this)

  slide: ($el, ending, complete) ->
    if @firstSlide
      $el.css ending
      @firstSlide = false
      return complete()
    $el.animate ending, 800, complete

  dimensions: ($el) ->
    left = ($(window).width() - $el.width()) / 2
    left: left

  exit: ->
    $(@el).remove()
)

CommonPlace.registration.RegistrationModalPage = CommonPlace.View.extend(
  initialize: (options) ->
    @data = options.data or isFacebook: false
    @communityExterior = options.communityExterior
    @slideIn = options.slideIn
    @nextPage = options.nextPage
    @complete = options.complete
    @template = @facebookTemplate  if options.data and options.data.isFacebook and @facebookTemplate

  validate_registration: (params, callback) ->
    validate_api = "/api" + @communityExterior.links.registration.validate
    $.getJSON validate_api, @data, _.bind((response) ->
      @$(".error").hide()
      valid = true
      unless _.isEmpty(response.facebook)
        window.location.pathname = @communityExterior.links.facebook_login
      else
        _.each params, _.bind((field) ->
          unless _.isEmpty(response[field])
            error = @$(".error." + field)
            input = @$("input[name=" + field + "]")
            errorText = _.reduce(response[field], (a, b) ->
              a + " and " + b
            )
            input.addClass "input_error"
            error.text errorText
            error.show()
            valid = false
        , this)
        callback()  if valid and callback
    , this)
)
