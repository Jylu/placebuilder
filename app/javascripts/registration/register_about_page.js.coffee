CommonPlace.registration.AboutPageRegisterNewUserView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.new_about_page"
  facebookTemplate: "registration.facebook"
  events:
    "click button.next-button": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"

  afterRender: ->
    unless @current
      @slideIn @el
      @current = true
    @$("input[placeholder]").placeholder()
    if @data.isFacebook
      @$("input[name=full_name]").val @data.full_name
      @$("input[name=email]").val @data.email  if @isRealEmail()
    domains = ["hotmail.com", "gmail.com", "aol.com", "yahoo.com"]
    @$("input#email").blur ->
      $("input#email").mailcheck domains,
        suggested: (element, suggestion) ->
          $(".error.email").html "Did you mean " + suggestion.full + "?"
          $(".error.email").show()
          $(".error.email").click (e) ->
            $(element).val suggestion.full


        empty: (element) ->
          $(".error.email").hide()


    url = "/api/communities/" + @communityExterior.id + "/address_completions"
    @$("input[name=street_address]").autocomplete
      source: url
      minLength: 2


  community_name: ->
    @communityExterior.name

  learn_more: ->
    "/" + @communityExterior.slug + "/about"

  created_at: ->
    @communityExterior.statistics.created_at

  neighbors: ->
    @communityExterior.statistics.neighbors

  feeds: ->
    @communityExterior.statistics.feeds

  postlikes: ->
    @communityExterior.statistics.postlikes

  submit: (e) ->
    e.preventDefault()  if e
    @data.full_name = @$("input[name=full_name]").val()
    @data.email = @$("input[name=email]").val()
    @data.address = @$("input[name=street_address]").val()
    validate_api = "/api" + @communityExterior.links.registration.validate
    $.getJSON validate_api, @data, _.bind((response) ->
      @$(".error").hide()
      valid = true
      unless _.isEmpty(response.facebook)
        window.location.pathname = @communityExterior.links.facebook_login
      else
        _.each ["full_name", "email", "street_address"], _.bind((field) ->
          model_field_name = undefined
          if field is "street_address"
            model_field_name = "address"
          else
            model_field_name = field
          unless _.isEmpty(response[model_field_name])
            error = @$(".error." + field)
            errorText = _.reduce(response[model_field_name], (a, b) ->
              a + " and " + b
            )
            error.text errorText
            error.show()
            valid = false
        , this)
        if valid
          new_url = "/" + @communityExterior.slug + "/register/profile?name=" + @data.full_name + "&email=" + @data.email + "&address=" + @data.address
          window.location.href = new_url
    , this)

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_registration success: _.bind((data) ->
      @data = data
      @data.isFacebook = true
      @template = @facebookTemplate
      @render()
    , this)

  isRealEmail: ->
    return false  if not @data or not @data.email
    @data.email.search("proxymail") is -1
)
