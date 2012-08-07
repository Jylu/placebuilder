CommonPlace.views.ShareModal = CommonPlace.View.extend(
  template: "shared/share_modal"

  events:
    "click .share-f": "shareFacebook"
    "click .share-t": "shareTwitter"
    "click #emailshare": "showEmailShare"
    "click #linkshare": "showLinkShare"
    "click .green-button": "close"
    "click #submit_email_share": "submitEmail"

  initialize: (options) ->
    @account = options.account
    @header = options.header
    @message = options.message

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

    window.app.navigate(CommonPlace.community.get("slug"), {"trigger": true, "replace": true})
    this.remove()

  shareFacebook: (e) ->
    e.preventDefault()
    $link = $(e.target)
    FB.ui
      method: "feed"
      name: $link.attr("data-name")
      link: $link.attr("data-url")
      picture: $link.attr("data-picture")
      caption: $link.attr("data-caption")
      description: $link.attr("data-description")
      message: $link.attr("data-message")
    , $.noop

  shareTwitter: (e) ->
    e.preventDefault()
    $link = $(e.target)
    url = encodeURIComponent($link.attr("data-url"))
    text = $link.attr("data-message")
    share_url = "https://twitter.com/intent/tweet?url=" + url + "&text=" + text + "&count=horizontal"
    window.open share_url, "cp_share"

  showEmailShare: (e) ->
    e.preventDefault()
    @$("#share-email").toggle()

  showLinkShare: (e) ->
    e.preventDefault()
    @$("#share_link").toggle()

  submitEmail: (e) ->
    if e
      e.preventDefault()
    data =
      recipients: this.$("input[name=share-email]").val()

    $.ajax(
      type: "POST"
      url: "/api" + this.model.get("links").self + "/share_via_email"
      data: data
      success: (response) ->
        $("input[name=share-email]").val('')
        $("#share_success").toggle()
        _kmq.push(['record', 'Share', {'Medium': 'Email'}])
      dataType: "JSON"
    )
)
