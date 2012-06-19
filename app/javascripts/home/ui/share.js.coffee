Home.ui.Share = Framework.View.extend
  template: "home.share"

  #Do we need to pass in the post object when we create this?

  events:
    "click .green-button": "sharePost"
    "click .red-button": "remove"
    "click #facebookshare": "showFacebook"
    "click #emailshare": "showEmail"
    "click #linkshare": "showLink"

  render: (params) ->
    this.$el.html this.renderTemplate(params)

  sharePost: (e) ->
    if e
      e.preventDefault()
    router.navigate(router.community.get("slug") + "/home", {"trigger": true, "replace": true})
    this.remove()

  showFacebook: (e) ->
    if e
      e.preventDefault()
    this.$("#share_facebook").toggle()

  showEmail: (e) ->
    if e
      e.preventDefault()
    this.$("#share_email").toggle()

  showLink: (e) ->
    if e
      e.preventDefault()
    this.$("#share_link").toggle()
