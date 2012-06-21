Home.ui.Sidebar = Framework.View.extend
  template          : "home.sidebar"
  links_header_class: "sidebar-links"
  content_div       : "directory_content"
  neighbors         : undefined
  yourPages         : undefined

  render: (type, id = undefined) ->
    # renders sidebar template
    mainRender = (params) => this.$el.html this.renderTemplate(params)
    
    # renders top of sidebar
    topRender = (divs) ->
      execute = (params) =>
        if "post-button" in divs
          (new Home.ui.PostButton(el: this.$("#post-button"))).render()
        if "avatar" in divs
          (new Home.ui.Avatar(el: this.$("#avatar"))).render(params)
        if "about" in divs
          (new Home.ui.About(el: this.$("#about"))).render(params)
        if "contact" in divs
          (new Home.ui.Contact(el: this.$("#contact"))).render(params)
      if type is "page"
        router.community.getPage
          success: (data) =>
            data.each (p) =>
              page = p.toJSON()
              page.large_avatar = page.links.avatar.large
              execute(page)
          , id
      else
        execute()

    # renders filters
    filterRender = () ->
      (new Home.ui.Filters(el: this.$("#filters"))).render(type)
    
    # displays directory content
    showDirectory = (fxn, initial_dir) =>
      fxn()
      element = '[title="'+initial_dir+'"]'
      this.$(element).addClass('current_tab')

    # does all the above
    renderController = (params, fxn, initial_dir) =>
      mainRender(params)
      topRender(params.divs)
      filterRender()
      showDirectory(fxn, initial_dir)

    # directories (sidebar links) 
    make_link = (title, name) -> return { "title" : title, "name" : name }

    neighbors   = make_link("neighbors", "Your Neighbors")
    pages       = make_link("pages", "Your Pages")
    subscribers = make_link("subscribers", "Subscribers")
    
    # params for mainRender()
    home_params =
      divs  : ["post-button", "filters"]
      links : [pages, neighbors]
    page_params =
      divs  : ["avatar", "about", "contact", "filters"]
      links : [subscribers]

    # based on type, render main template and filters and show first directory
    switch type
      when "home"
        renderController(home_params, (() => this.showPages()), "pages")
      when "page"
        renderController(page_params, (() => this.showSubscribers()), "subscribers")

  showNeighbors: ->
    neighbors_params =
      "title"       : "Your Neighbors"
      "header_class": this.links_header_class
      "links_id"    : "your-neighbors-links"
    
    if this.neighbors is undefined
      this.neighbors = new Home.ui.Neighbors(el: this.$("#"+this.content_div))
    this.neighbors.render(neighbors_params)
    this.resizeDirectory()

  showPages: ->
    pages_params =
      "title"       : "Your Pages"
      "header_class": this.links_header_class
      "links_id"    : "your-pages-links"
    if this.yourPages is undefined
      this.yourPages = new Home.ui.YourPages(el: this.$("#"+this.content_div))
    this.yourPages.render(pages_params)
    this.resizeDirectory()

  showSubscribers: ->
    ###
    # TODO
    subscribers_params =
      "title"       : "Subscribers"
      "header_class": this.links_header_class
      "links_id"    : "subscribers-links"
      "page"        : this.page
    if this.subscribers is undefined
      this.subscribers = new Home.ui.Subscribers(el: this.$("#"+this.content_div))
    this.subscribers.render(subscribers_params)
    this.resizeDirectory()###
    this.showPages()

  resizeDirectory: ->
    height = 0
    body = window.document.body
    if window.innerHeight isnt undefined
      height = window.innerHeight
    else if body.parentElement.clientHeight isnt undefined
      height = body.parentElement.clientHeight
    else if body and body.clientHeight
      height = body.clientHeight
    
    offset = this.$("#"+this.content_div).offset()
    directory_height = height - offset.top - 10
    this.$("#"+this.content_div).height(directory_height+"px")

  switchTabs: (e) ->
    e.preventDefault()
    title = this.$(e.currentTarget).attr("title")
    this.$('.sidebar-links').removeClass('current_tab')
    this.$(e.currentTarget).addClass('current_tab')
    if title is "pages"
      this.showPages()
    else if title is "neighbors"
      this.showNeighbors()

  showScrollBar: (e) ->
    e.preventDefault()
    this.$(e.currentTarget).css({"overflow": "auto"})

  hideScrollBar: (e) ->
    e.preventDefault()
    this.$(e.currentTarget).css({"overflow": "hidden"})

  events:
    "click .sidebar-links": "switchTabs"
    "mouseover .scroll": "showScrollBar"
    "mouseout .scroll": "hideScrollBar"
