Home.ui.Header = Framework.View.extend
  template: "home.header"

  render: (params) ->
    this.$el.html this.renderTemplate(params)

