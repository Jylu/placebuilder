Home.ui.RegistrationHeader = Framework.View.extend
  template: "home.registration-header"

  events:
    "click #login": "showLogin"

  render: (params) ->
    this.$el.html this.renderTemplate(params)

  showLogin: (e) ->
    if e
      e.preventDefault()
    if this.$(".dropdown").css("opacity") is "1"
      this.$(".dropdown").fadeTo("fast", "0")
    else 
      this.$(".dropdown").fadeTo("fast", "1")
