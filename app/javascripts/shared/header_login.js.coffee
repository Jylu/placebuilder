CommonPlace.shared.HeaderLogin = CommonPlace.View.extend(
  template: "shared.header-login"
  id: "user_sign_in"
  tagName: "ul"
  events:
    "click #login": "toggleForm"
    "click button[name=signin]": "login"
    "submit form": "login"

  afterRender: ->
    @$("#sign_in").hide()

  toggleForm: (e) ->
    e.preventDefault()  if e
    @$("#sign_in").toggle()

  create_error: (text) ->
    "<li class='error'>" + text + "</li>"

  root_url: ->
    if CommonPlace.account.isAuth()
      "/" + CommonPlace.account.get("community_slug")
    else
      "/" + CommonPlace.community.get("slug")  if CommonPlace.community

  hasCommunity: ->
    CommonPlace.community

  community_name: ->
    if CommonPlace.account.isAuth()
      CommonPlace.account.get "community_name"
    else
      CommonPlace.community.get "name"  if CommonPlace.community

  login: (e) ->
    e.preventDefault()  if e
    @$(".notice").html ""
    @$(".error").removeClass "error"
    email = @$("input[name=email]").val()
    unless email
      @$("#errors").append @create_error("Please enter an e-mail address")
      @$("input[name=email]").addClass "error"
      return
    password = @$("input[name=password]").val()
    unless password
      @$("#errors").append @create_error("Please enter a password")
      @$("input[name=password]").addClass "error"
      return
    $.postJSON
      url: "/api/sessions"
      data:
        email: email
        password: password

      success: ->
        window.location = "/users/sign_in"

      error: _.bind(->
        window.location = "/login_failed"
      , this)

)
