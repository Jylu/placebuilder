Home.ui.Post = Home.ui.WireItem.extend
  template: "home.post"

  className: "wire"

  events:
    "click .reply": "toggleReplies"
    "click .thank": "thank"
    "click .help": "publicize"
    "click #post-reply-button": "reply"

  render: ->
    presenter = new Home.presenter.Post(this.model)
    this.$el.html this.renderTemplate(presenter.toJSON())
    this.checkThanked()

  toggleReplies: (e) ->
    e.preventDefault()
    this.$("#post-replies").toggle()

