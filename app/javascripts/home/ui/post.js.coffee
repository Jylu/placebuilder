Home.ui.Post = Home.ui.WireItem.extend
  template: "home.post"

  className: "wire"

  events:
    "click .reply": "showReply"
    "click .thank": "thank"
    "click .help": "publicize"
    "click .post-reply-button": "reply"

  initialize: ->
    _.bindAll(this)
    @reply_text_class = "post-reply"
    @reply_button_class = "post-reply-button"

  render: ->
    presenter = new Home.presenter.Post(this.model)
    this.$el.html this.renderTemplate(presenter.toJSON())

    @reply_text = this.$("."+@reply_text_class)
    @reply_button = this.$("."+@reply_button_class)
    this.checkThanked()
    this.hideReplyButton()
    @reply_text.focus(this.showReplyButton)
    @reply_text.blur(this.hideReplyButton)

  showReply: (e) ->
    @reply_text.focus()

  showReplyButton: (e) ->
    @reply_button.show()
    
  hideReplyButton: (e) ->
    if @reply_text.val().length is 0
      @reply_button.hide()
    
