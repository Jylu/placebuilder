CommonPlace.main.YourTown = CommonPlace.View.extend
  template: "main_page.your-town"

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = undefined
    if content isnt undefined
      _kmq.push(['record', 'Wire Engagement', { 'Type': 'Tab', 'Tab': category }]);
      content.render(category)

  events:
    "click a" : "showPosts"
