Home.ui.YourTown = Framework.View.extend
  template: "home.your-town"

  render: () ->
    this.$el.html this.renderTemplate()

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = router.content
    if content isnt undefined
      _kmq.push(['record', 'Wire Engagement', { 'Type': 'Tab', 'Tab': category }]);
      content.render(category)

  events:
    "click a" : "showPosts"
