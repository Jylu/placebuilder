Home.ui.YourTown = Framework.View.extend
  template: "home.your-town"

  render: (params) -> 
    this.$el.html this.renderTemplate(params)

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = router.content
    if content isnt undefined
      content.render(category)

  events:
    "click a" : "showPosts"
