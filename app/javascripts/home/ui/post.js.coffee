Home.ui.Post = Framework.View.extend
  template: "home.post"

  className: "wire"

  events:
    "click .post-replies": "toggleReplies"

  render: ->
    presenter = new Home.presenter.Post(this.model)
    this.$el.html this.renderTemplate(presenter.toJSON())

  toggleReplies: (e) ->
    e.preventDefault()
    this.$("#post-replies").toggle()
