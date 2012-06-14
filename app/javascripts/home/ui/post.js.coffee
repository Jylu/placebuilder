Home.ui.Post = Home.ui.WireItem.extend
  template: "home.post"

  className: "wire"

  events:
    "click .post-replies": "toggleReplies"
    "click .thank": "thank"

  render: ->
    presenter = new Home.presenter.Post(this.model)
    this.$el.html this.renderTemplate(presenter.toJSON())
    this.checkThanked()

  toggleReplies: (e) ->
    e.preventDefault()
    this.$("#post-replies").toggle()

