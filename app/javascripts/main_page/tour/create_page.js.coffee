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
    feed_data =
      name: @$("input[name=name]").val()
      about: @$("textarea[name=about]").val()
      address: @$("input[name=address]").val()
      website: @$("input[name=website]").val()
      phone: @$("input[name=phone]").val()
      tags: @$("input[name=tags]").val()

    $.ajax
      type: "post"
      url: "/api" + CommonPlace.community.feeds.uri
      data: JSON.stringify(feed_data)
      dataType: "json"
      success: _.bind((feed) ->
        self.nextPage "subscribe", self.data
      error: (attribs, response) ->
        $error = @$(".error")
        $error.html "Error creating feed"
        $error.show()
      , this)

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
