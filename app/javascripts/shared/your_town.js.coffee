CommonPlace.shared.YourTown = CommonPlace.View.extend
  template: "shared.sidebar.your-town"
  id      : "your-town"

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = undefined
    if content isnt undefined
      _kmq.push(['record', 'Wire Engagement', { 'Type': 'Tab', 'Tab': category }])
      content.render(category)

  events:
    "click a" : "showPosts"
