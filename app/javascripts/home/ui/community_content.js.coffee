Home.ui.CommunityContent = Framework.View.extend
  template: "home.community-content"

  className: "main"
  category: ""
  categories: ["all posts", "volunteering", "city problems", "safety", "news", "health and wellness", "schools", "request",  "offer", "event"]

  render: ->
    console.log "content render"
    this.$el.html this.renderTemplate()
    this.addTab(category) for category in this.categories
    this.showPosts()

  addTab: (category) ->
    category_name = (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
    this.$(".navigation").append("<button class='tab-button' value='"+category+"'>"+category_name+"</button>")

  showPosts: () ->
    if this.category in this.categories
      if this.category is "all posts"
        this.category = ""
    else
      this.category = ""
    router.community.getPosts
      limit: 5
      success: (posts) =>
        posts.each (p) =>
          view = new Home.ui.Post(model: p)
          view.render()
          this.$(".list").append(view.el)
      , this.category

  tabClick: (e) ->
    e.preventDefault()
    this.category = this.$(e.currentTarget).attr("value")
    this.render()

  events:
    "click .tab-button" : "tabClick" 




