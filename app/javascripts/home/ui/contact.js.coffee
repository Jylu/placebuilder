Home.ui.Contact = Framework.View.extend
  template: "home.contact"

  render: (params) ->
    # TODO: start soliciting short names that fit on a button
    params.short_name = params.name.split(" ")[0]

    this.$el.html this.renderTemplate(params)
