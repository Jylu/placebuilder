Home.ui.About = Framework.View.extend
  template: "home.about"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
