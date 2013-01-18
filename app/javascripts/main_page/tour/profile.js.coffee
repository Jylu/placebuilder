CommonPlace.main.ProfileView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.profile"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click img.facebook": "facebook"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @$('input[placeholder], textarea[placeholder]').placeholder()
    @initAvatarUploader @$(".avatar_file_browse")  unless @data.isFacebook
    unless @current
      @fadeIn @el
      @current = true
    @$("select.list").chosen().change {}, ->
      clickable = $(this).parent("li").children("div").children("ul")
      clickable.click()

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  avatar_url: ->
    (if (@data.avatar_url) then @data.avatar_url else "")

  submit: (e) ->
    self = this
    e.preventDefault()  if e
    @$(".error").hide()
    @data.about = @$("textarea[name=about]").val()
    @data.organizations = @$("input[name=organizations]").val()
    _.each [ "interests", "skills", "goods" ], _.bind((listname) ->
      list = @$("select[name=" + listname + "]").val()
      @data[listname] = list.toString()  unless _.isEmpty(list)
    , this)

    CommonPlace.account.save(@data,
      success: (response) ->
        if self.hasAvatarFile and not self.data.isFacebook
          self.avatarUploader.submit()
        self.nextPage "create_page", self.data
    )

  skills: ->
    @community.get("skills")

  interests: ->
    @community.get("interests")

  goods: ->
    @community.get("goods")

  initAvatarUploader: ($el) ->
    self = this
    @avatarUploader = new AjaxUpload($el,
      action: "/api" + @community.get("links").registration.avatar
      name: "avatar"
      data: {}
      responseType: "json"
      autoSubmit: true
      onChange: ->
        self.toggleAvatar()

      onSubmit: (file, extension) ->

      onComplete: (file, response) ->
        CommonPlace.account.set response
        $(".profile_pic").attr("src", CommonPlace.account.get("avatar_url"))
    )

  toggleAvatar: ->
    @hasAvatarFile = true
    @$("a.avatar_file_browse").html "Photo Added! ✓"

  facebook: (e) ->
    e.preventDefault()  if e
    facebook_connect_avatar success: _.bind((data) ->
      @data.isFacebook = true
      @data = _.extend(@data, data)
      @toggleAvatar()
      $(".profile_pic").attr("src", @data.avatar_url)
    , this) if not @data.isFacebook

)
