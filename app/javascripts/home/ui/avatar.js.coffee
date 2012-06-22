Home.ui.Avatar = Framework.View.extend
  template: "home.avatar"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
