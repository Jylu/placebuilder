CommonPlace.views.ShareModal = FormView.extend(
  template: "shared/share_modal"

  events:
    "click #facebookshare": "shareFacebook"
    "click #twittershare": "shareTwitter"
    "click #linkshare": "showLinkShare"
    "click .green-button": "exit"
    "click .close": "exit"
    "click #submit_email_share": "submitEmail"
    "click #mailto-share": "markEmailShareChecked"

  initialize: (options) ->
    options.template = @template
    options.el = @el
    FormView.prototype.initialize options
    @account = options.account
    @header = options.header
    @message = options.message

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

  email_subject: ->
    "Check out this post on OurCommonPlace #{@community_name()}"

  email_body: ->
    "I thought you might like this post on OurCommonPlace, #{@community_name()}'s online town bulletin: #{@share_url()}"

  community_name: ->
    CommonPlace.community.get "name"

  shareFacebook: (e) ->
    e.preventDefault()
    $('.share-f').addClass("checked")
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
    $('.share-t').addClass("checked")
    $link = $(e.target)
    url = encodeURIComponent($link.attr("data-url"))
    text = $link.attr("data-message")
    share_url = "https://twitter.com/intent/tweet?url=" + url + "&text=" + text + " " + url + "&count=horizontal"
    window.open share_url, "cp_share", 'height=500,width=500'

  markEmailShareChecked: (e) ->
    e.preventDefault if e
    $("#emailshare").addClass("checked")
    _kmq.push(['record', 'Share', {'Medium': 'Email'}]) if _kmq?

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

    $.ajax(
      type: "POST"
      url: "/api" + this.model.get("links").self + "/share_via_email"
      data: data
      success: (response) ->
        $("input[name=share-email]").val('')
        $("#emailshare").addClass("checked")
        _kmq.push(['record', 'Share', {'Medium': 'Email'}]) if _kmq?
      dataType: "JSON"
    )
)
