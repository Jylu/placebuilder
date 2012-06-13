Home.ui.CommunityContent = Framework.View.extend
  template: "home.community-content"

  className: "main"
  category: ""
  categories: ["discussion", "request", "event"]

  render: (type, category) ->
    console.log "content render"
    this.$el.html this.renderTemplate()
    if type is "page"
      this.showPage(category)
    else
      this.showPosts(category)

  showPosts: (category) ->
    if category
      category = category.toLowerCase()
    if category in this.categories
    else
      category = ""
    router.community.getPosts
      limit: 5
      success: (posts) =>
        posts.each (p) =>
          view = new Home.ui.Post(model: p)
          view.render()
          this.$(".list").append(view.el)
      , category

  showPage: (page) ->
    router.community.getPageContent
      limit: 5
      success: (posts) =>
        posts.each (p) =>
          view = new Home.ui.Post(model: p)
          view.render()
          this.$(".list").append(view.el)
      , page

