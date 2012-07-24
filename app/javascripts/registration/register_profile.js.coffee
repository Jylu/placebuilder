CommonPlace.registration.ProfileView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.home_profile"
  facebookTemplate: "registration.facebook_profile"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @initReferralQuestions()
    @initAvatarUploader @$(".avatar_file_browse")  unless @data.isFacebook
    unless @current
      @slideIn @el
      @current = true
    @$("select.list").chosen().change {}, ->
      clickable = $(this).parent("li").children("div").children("ul")
      clickable.click()

  community_name: ->
    @communityExterior.name

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  avatar_url: ->
    (if (@data.avatar_url) then @data.avatar_url else "")

  submit: (e) ->
    e.preventDefault()  if e
    @$(".error").hide()
    @data.about = @$("textarea[name=about]").val()
    @data.organizations = @$("input[name=organizations]").val()
    _.each [ "interests", "skills", "goods" ], _.bind((listname) ->
      list = @$("select[name=" + listname + "]").val()
      @data[listname] = list.toString()  unless _.isEmpty(list)
    , this)
    new_api = "/api" + @communityExterior.links.registration[(if (@data.isFacebook) then "facebook" else "new")]
    $.post new_api, @data, _.bind((response) ->
      if response.success is "true" or response.id
        CommonPlace.account = new Account(response)
        if @hasAvatarFile and not @data.isFacebook
          @avatarUploader.submit()
        else
          @nextPage "feed", @data
      else
        unless _.isEmpty(response.facebook)
          window.location.pathname = @communityExterior.links.facebook_login
        else unless _.isEmpty(response.password)
          @$(".error").text response.password[0]
          @$(".error").show()
    , this)

  skills: ->
    @communityExterior.skills

  interests: ->
    @communityExterior.interests

  goods: ->
    @communityExterior.goods

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

  toggleAvatar: ->
    @hasAvatarFile = true
    @$("a.avatar_file_browse").html "Added a photo ✓"

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

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_avatar success: _.bind((data) ->
      @data.isFacebook = true
      @data = _.extend(@data, data)
      @template = "registration.facebook_profile"
      @render()
    , this)

  isWatertown: ->
    CommonPlace.community.get("name") is "Watertown"
)
