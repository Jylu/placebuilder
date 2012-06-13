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
        this.timeHeaders()
        this.multiColumn()
        $(window).scroll(() =>
          this.updateHeader()
        )
      , page

  timeHeaders: () ->
    previousN = 0
    previousUnit = "recent"
    notRecent = ["week", "weeks", "month", "months", "year", "years"]
    $(".wire").each(() ->
      headerName = false
      tAgo = $(this).find(".wire-top").attr("data-time-ago")
      tSplit = tAgo.split(" ")
      currentN = tSplit[0]
      currentUnit = tSplit[1]
      if $.inArray(currentUnit, notRecent) == -1
        currentUnit = "recent"
      if previousUnit == currentUnit
        if previousN == 0
          headerName = "Recent Posts"
        else if previousN != currentN
          headerName = tAgo
      else
        headerName = tAgo
      if (headerName)
        $(this).before("<div class='wire-header'><h3>#{headerName}</h3></div>")
      previousN = currentN
      previousUnit = currentUnit
    )

  multiColumn: () ->
    $(".main").addClass("multi-column")
    $(".list").addClass("multi-column").removeClass("one-column")
    container = $("#content").find(".list")
    container.imagesLoaded( () ->
      container.masonry({
        #containerStyle: 'margin: 0 auto',
        itemSelector: '.wire, .wire-header'
        #isFitWidth: true,
        #isResizable: true,
        columnWidth: 370
      })
    )

  updateHeader: () ->
    $(".wire-header").each(() ->
      if($(this).offset().top < $(window).scrollTop())
        $("h2").html($(this).find("h3").html())
    )

