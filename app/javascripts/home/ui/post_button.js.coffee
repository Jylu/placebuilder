Home.ui.PostButton = Framework.View.extend
  template: "home.post-button"

  render: ->
    this.$el.html this.renderTemplate()

  # events:
    # "click": -> << create-post >>
