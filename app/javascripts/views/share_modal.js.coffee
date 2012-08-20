CommonPlace.views.ShareModal = CommonPlace.View.extend(
  template: "shared/share_modal"

  events:
    "click #facebookshare": "shareFacebook"
    "click #twittershare": "shareTwitter"
    "click #emailshare": "showEmailShare"
    "click #linkshare": "showLinkShare"
    "click .green-button": "close"
    "click #submit_email_share": "submitEmail"

  initialize: (options) ->
    @account = options.account
    @header = options.header
    @message = options.message
    @facebook_share = false

  afterRender: ->

  avatar_url: ->
    url = @model.get("avatar_url")
    return "https://www.ourcommonplace.com/images/logo-pin.png"  if url is "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
    url

  share_url: ->
    CommonPlace.community.get("links")["base"] + "/show/" + @model.get("schema") + "/" + @model.get("id")

  header: ->
    if @header
      @header

  message: ->
    if @message
      @message

  item_name: ->
    @model.get "title"

  community_name: ->
    CommonPlace.community.get "name"

  close: (e) ->
    if e
      e.preventDefault()

    if this.$("input[name=share-email]").val()
      this.submitEmail()


    user = new User({links: { self: "/users/" + CommonPlace.account.get("id")}})
    user.fetch
      success: ->
        @test = user

    window.app.navigate(CommonPlace.community.get("slug"), {"trigger": true, "replace": true})
    this.remove()

  shareFacebook: (e) ->
    e.preventDefault()
    $link = $(e.target)
    @share_info =
      method: "feed"
      name: $link.attr("data-name")
      link: $link.attr("data-url")
      picture: $link.attr("data-picture")
      caption: $link.attr("data-caption")
      description: $link.attr("data-description")
      message: $link.attr("data-message")
    if @account.get("facebook_user")
      @facebook_share = not @facebook_share
      if @facebook_share
        $('.share-f').addClass("checked")
      else
        $('.share-f').removeClass("checked")
    else
      $('.share-f').addClass("checked")
      FB.ui @share_info
      , $.noop

  shareTwitter: (e) ->
    e.preventDefault()
    $('.share-t').addClass("checked")
    $link = $(e.target)
    url = encodeURIComponent($link.attr("data-url"))
    text = $link.attr("data-message")
    share_url = "https://twitter.com/intent/tweet?url=" + url + "&text=" + text + " " + url + "&count=horizontal"
    window.open share_url, "cp_share"

  showEmailShare: (e) ->
    e.preventDefault()
    @$("#share-email").toggle()

  showLinkShare: (e) ->
    e.preventDefault()
    @$("#share_link").toggle()
    $("#linkshare").addClass("checked")

  submitEmail: (e) ->
    if e
      e.preventDefault()
    data =
      recipients: this.$("input[name=share-email]").val()

    if data.recipients isnt ""
      $("#emailshare").addClass("checked")

    facebook_stream_publish @share_info

    $.ajax(
      type: "POST"
      url: "/api" + this.model.get("links").self + "/share_via_email"
      data: data
      success: (response) ->
        $("input[name=share-email]").val('')
        $("#emailshare").addClass("checked")
        _kmq.push(['record', 'Share', {'Medium': 'Email'}])
      dataType: "JSON"
    )
)
