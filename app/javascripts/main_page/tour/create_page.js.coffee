CommonPlace.main.CreatePageView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.create_page"
  events:
    "click input.continue": "submit"
    "submit form": "submit"
    "click .next-button": "submit"

  afterRender: ->
    @hasAvatarFile = false
    @$('input[placeholder], textarea[placeholder]').placeholder()
    @initAvatarUploader @$(".avatar_file_browse")
    @$("select.dk").dropkick()
    unless @current
      @fadeIn @el
      @current = true

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
      kind: @$("select[name=page_kind]").val()

    $.ajax
      type: "post"
      url: "/api" + CommonPlace.community.feeds.uri
      data: JSON.stringify(feed_data)
      dataType: "json"
      success: _.bind((feed) ->
        self.nextPage "subscribe", self.data
      , this)
      error: (attribs, response) ->
        $error = @$(".error")
        $error.html "Error creating feed"
        $error.show()

  initAvatarUploader: ($el) ->
    self = this
    @avatarUploader = new AjaxUpload($el,
      action: "/api" + CommonPlace.community.get("links").registration.avatar
      name: "avatar"
      data: {}
      responseType: "json"
      autoSubmit: false
      onChange: (file, extension) ->
        self.toggleAvatar()
        $(".profile_pic").attr("src", file)

      onSubmit: (file, extension) ->

      onComplete: (file, response) ->
    )

  toggleAvatar: ->
    @hasAvatarFile = true
    @$("a.avatar_file_browse").html "Photo Added! ✓"
)
