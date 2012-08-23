CommonPlace.registration.AddressView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.address"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @initReferralQuestions()
    @$("select.dk").dropkick()
    unless @current
      @slideIn @el
      @current = true
    url = "/api/communities/" + @communityExterior.id + "/address_completions"
    @$("input[name=street_address]").autocomplete
      source: url
      minLength: 1

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.address = @$("input[name=street_address]").val()
    @data.referral_source = @$("select[name=referral_source]").val()
    @data.referral_metadata = @$("input[name=referral_metadata]").val()
    @data.organizations = ""
    new_api = "/api" + @communityExterior.links.registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        if @hasAvatarFile and not @data.isFacebook
          @avatarUploader.submit()
        else
          @complete()
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = @communityExterior.links.facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)

  referrers: ->
    @communityExterior.referral_sources

  initAvatarUploader: ($el) ->
    self = this
    @avatarUploader = new AjaxUpload($el,
      action: "/api" + @communityExterior.links.registration.avatar
      name: "avatar"
      data: {}
      responseType: "json"
      autoSubmit: false
      onChange: ->
        self.toggleAvatar()

      onSubmit: (file, extension) ->

      onComplete: (file, response) ->
        CommonPlace.account.set response
        self.nextPage "crop", @data
    )

  initReferralQuestions: ->
    @$("select[name=referral_source]").bind "change", _.bind(->
      question =
        "At a table or booth at an event": "What was the event?"
        "In an email": "Who was the email from?"
        "On Facebook or Twitter": "From what person or organization?"
        "On another website": "What website?"
        "In the news": "From which news source?"
        "Word of mouth": "From what person or organization?"
        "Flyer from a business or organization": "Which business or organization?"
        Other: "Where?"
      [@$("select[name=referral_source] option:selected").val()]
      if question
        @$(".referral_metadata_li").show()
        @$(".referral_metadata_li label").html question
      else
        @$(".referral_metadata_li").hide()
    , this)
)
