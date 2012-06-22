Home.ui.Filters = Framework.View.extend
  template: "home.filters"

  render: (type) ->
    make_filter = (id, name) -> return { "id" : id, "name" : name }

    announcement = make_filter("announcement", "Announcements")
    discussion   = make_filter("discussion", "Town Discussions")
    event        = make_filter("event", "Events & Meetups")
    request      = make_filter("request", "Requests & Offers")

    home_params = filters : [request, event, discussion, announcement]
    page_params = filters : [event, announcement, request]

    switch type
      when "home" then this.$el.html this.renderTemplate(home_params)
      when "page" then this.$el.html this.renderTemplate(page_params)

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = router.content
    if content isnt undefined
      content.render(category)

  events:
    "click a" : "showPosts"
