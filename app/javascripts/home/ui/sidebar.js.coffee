Home.ui.Sidebar = Framework.View.extend
  template          : "home.sidebar"
  links_header_class: "sidebar-links"
  content_div       : "directory_content"
  neighbors         : undefined
  yourPages         : undefined

  render: ->
    this.$el.html this.renderTemplate()

    this.yourTown = new Home.ui.YourTown(el: this.$("#your-town"))
    this.yourTown.render()

    #show the your pages tab by default
    this.showPages()

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
    this.$("#"+this.content_div).height((height - offset.top)+"px")

  switchTabs: (e) ->
    e.preventDefault()
    title = this.$(e.currentTarget).attr("title")
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
