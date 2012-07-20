Home.ui.Share = Framework.View.extend
  template: "home.share"

  #Do we need to pass in the post object when we create this? - maybe, still working on that

  events:
    "click .green-button": "close"
    "click #emailshare": "showEmail"
    "click #linkshare": "showLink"
    "click #submit_email_share": "submitEmails"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    this.$("#share_email").hide()
    this.$("#share_link").hide()
    this.model = params.model

  close: (e) ->
    if e
      e.preventDefault()

    if this.$("input[name=share-email]").val()
      this.submitEmails()

    router.navigate(router.community.get("slug") + "/home", {"trigger": true, "replace": true})
    this.remove()

  showEmail: (e) ->
    if e
      e.preventDefault()
    this.$("#share_email").toggle()

  showLink: (e) ->
    if e
      e.preventDefault()
    this.$("#share_link").toggle()

  submitEmails: (e) ->
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


