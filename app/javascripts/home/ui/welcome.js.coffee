Home.ui.Welcome = Framework.View.extend
  template: "home.welcome"

  render: () ->
    this.$el.html this.renderTemplate()
