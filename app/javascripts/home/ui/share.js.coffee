Home.ui.Share = Framework.View.extend
  template: "home.share"

  #Do we need to pass in the post object when we create this? - maybe, still working on that

  events:
    "click .green-button": "close"
    "click #emailshare": "showEmail"
    "click #linkshare": "showLink"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    this.$("#share_email").hide()
    this.$("#share_link").hide()

  close: (e) ->
    if e
      e.preventDefault()
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
