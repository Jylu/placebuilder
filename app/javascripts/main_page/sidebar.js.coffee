CommonPlace.main.Sidebar = CommonPlace.View.extend
  template          : "main_page.sidebar"
  id                : "sidebar"
  links_header_class: "sidebar-links"
  content_div       : "directory_content"

  initialize: (options) ->
    @tabs = {
      neighbors: ->
        new CommonPlace.main.Neighbors()
      pages: ->
        new CommonPlace.main.YourPages()
    }

  afterRender: ->
    self = this
    yourTown = new CommonPlace.main.YourTown()
    yourTown.render()
    @$("#your-town").replaceWith(yourTown.el)

    #show the your pages tab by default
    @showTab("pages")
    @$('[title="pages"]').addClass('current_tab')
    $(window).resize(_.bind(@resizeDirectory, this))

  switchTabs: (e) ->
    e.preventDefault()
    title = @$(e.currentTarget).attr("title")
    @showTab(title)

  showTab: (title) ->
    if title of @tabs
      @$('.sidebar-links').removeClass('current_tab')
      @$('[title="'+title+'"]').addClass('current_tab')
      view = @tabs[title]()
      view.render()
      @$("#"+@content_div).html(view.el)
      @resizeDirectory()

  resizeDirectory: ->
    height = 0
    body = window.document.body
    if window.innerHeight isnt undefined
      height = window.innerHeight
    else if body.parentElement.clientHeight isnt undefined
      height = body.parentElement.clientHeight
    else if body and body.clientHeight
      height = body.clientHeight
    
    offset = @$("#"+@content_div).offset()
    if offset.top is 0
      directory_height = height - 435
    else
      directory_height = height - offset.top - 10
    @$("#"+@content_div).height(directory_height+"px")

  showScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow": "auto"})

  hideScrollBar: (e) ->
    e.preventDefault()
    @$(e.currentTarget).css({"overflow": "hidden"})

  events:
    "click .sidebar-links": "switchTabs"
    "mouseover .scroll": "showScrollBar"
    "mouseout .scroll": "hideScrollBar"
