Home.ui.Share = Framework.View.extend
  template: "home.share"

  #Do we need to pass in the post object when we create this?

  events:
    "click .green-button": "close"
    "click #facebookshare": "shareFacebook"
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

  shareFacebook: (e) ->
    if e
      e.preventDefault()
    #this.$("#share_facebook").toggle()
    link = $(e.target)
    FB.ui({
      method: 'feed',
      name: link.attr("data-name"),
      link: link.attr("data-url"),
      picture: link.attr("data-picture"),
      caption: link.attr("data-caption"),
      description: link.attr("data-description"),
      message: link.attr("data-message")
    }, $.noop)

  showEmail: (e) ->
    if e
      e.preventDefault()
    this.$("#share_email").toggle()

  showLink: (e) ->
    if e
      e.preventDefault()
    this.$("#share_link").toggle()
