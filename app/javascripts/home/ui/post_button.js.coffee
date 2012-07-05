Home.ui.PostButton = Framework.View.extend
  template: "home.post-button"

  render: ->
    this.$el.html this.renderTemplate()

  createPost: ->
    _kmq.push(['record', 'Wire Engagement', {'Type': 'Post Button'}]);

  events:
    "click": -> createPost
