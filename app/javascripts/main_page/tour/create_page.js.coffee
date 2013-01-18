CommonPlace.main.CreatePageView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.create_page"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @$('input[placeholder], textarea[placeholder]').placeholder()
    #@initAvatarUploader @$(".avatar_file_browse")
    unless @current
      @fadeIn @el
      @current = true

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  avatar_url: ->
    (if (@data.avatar_url) then @data.avatar_url else "")

  submit: (e) ->
    self = this
    e.preventDefault()  if e
    @$(".error").hide()
    @nextPage "subscribe", self.data

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
)
