Home.ui.Welcome = Framework.View.extend
  template: "home.welcome"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
