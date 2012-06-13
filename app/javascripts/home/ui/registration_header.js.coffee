Home.ui.RegistrationHeader = Framework.View.extend
  template: "home.registration-header"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
