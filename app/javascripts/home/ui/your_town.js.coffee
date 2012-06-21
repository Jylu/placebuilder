Home.ui.YourTown = Framework.View.extend
  template: "home.your-town"

  render: () ->
    this.$el.html this.renderTemplate()

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = router.content
    if content isnt undefined
      content.render(category)

  events:
    "click a" : "showPosts"
