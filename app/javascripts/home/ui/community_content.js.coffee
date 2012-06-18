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
        this.multiColumn($("#content").find(".list"), ".wire")
        this.dynamicHeader("h2", ".wire")
      , page

  timeHeaders: () ->
    # if a post is more than a week old, it does not go under the "Recent Posts" header
    notRecent = ["week", "weeks", "month", "months", "year", "years"]
    
    # initialize external vars
    header = ""
    jqStack = $([])
    superThis = this

    # iterate through posts
    $(".wire").each(() ->
      # get publishedAt string, granular to "this week" else month-of-posting
      publishedAtISO = $(this).find(".wire-top").attr("data-published-at")
      publishedAt = timeAgoThisWeekThenMonths(publishedAtISO)
      $(this).attr("data-header", publishedAt)

      # if header and publishedAt do not match we need a new group
      needNew = false
      if publishedAt != header
        needNew = true
      
      if needNew
        # if current stack exists, wrap with group
        if jqStack.length > 0
          superThis.wrapHeaderGroup(jqStack, header)
        # reset jqStack, update header
        jqStack = $([])
        header = publishedAt

      # push current post onto stack
      jqStack = jqStack.add($(this))
    )

    # finally, wrap any posts left on the stack
    if jqStack.length > 0
      this.wrapHeaderGroup(jqStack, header)

  wrapHeaderGroup: (jqStack, header) ->
    jqStack.wrapAll(
      "<div class='wire-group' data-header='" + header + "' />"
    )
    ###
    # inserts physical headers
    jqStack.first().before(
      "<div class='wire-header'>
        <div class='header-display'>
          <h3>#{header}</h3>
        </div>
      </div>"
    )
    jqStack.wrapAll(
      "<div class='wires' />"
    )###

  multiColumn: (container, selector) ->
    $(".main").add(container).add(container.find(selector)).addClass("multi-column")
    
    container.imagesLoaded( () ->
      container.masonry({
        columnWidth: 370
        isResizable: true,
        itemSelector: selector
      })
    )

  dynamicHeader: (header, messenger) ->
    $(header).append("<span class='subheader'></span>")
    this.updateHeader(".subheader", messenger)
    $(window).scroll(() =>
      this.updateHeader(".subheader", messenger)
    )

  updateHeader: (header, messenger) ->
    $(messenger).each(() ->
      if($(this).offset().top < $(window).scrollTop() + 100)
        $(header).html(" &bull; " + $(this).attr("data-header"))
    )

