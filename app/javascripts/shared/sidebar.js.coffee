CommonPlace.shared.Sidebar = CommonPlace.View.extend
  template          : "shared.sidebar"
  id                : "sidebar"
  links_header_class: "sidebar-links"
  content_div       : "directory_content"

  initialize: (options) ->
    @tabs = options.tabs
    @tabviews = options.tabviews
    @nav = options.nav

  afterRender: ->
    self = this
    #yourTown = new CommonPlace.shared.YourTown()
    @nav.render()
    @$("#your-town").replaceWith(@nav.el)

    #show the your pages tab by default
    @showTab("pages")
    @$('[title="pages"]').addClass('current_tab')
    $(window).resize(_.bind(@resizeDirectory, this))

  showPostbox: (e) ->
    if e
      e.preventDefault()
    @postbox = new CommonPlace.main.PostBox
      account: CommonPlace.account
      community: CommonPlace.community
    @postbox.render()
    $("#modal").html(@postbox.el)

  switchTabs: (e) ->
    e.preventDefault()
    title = @$(e.currentTarget).attr("title")
    @showTab(title)

  showTab: (title) ->
    if title of @tabviews
      @$('.sidebar-links').removeClass('current_tab')
      @$('[title="'+title+'"]').addClass('current_tab')
      view = @tabviews[title]
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
    "click .post": "showPostbox"
    "mouseover .scroll": "showScrollBar"
    "mouseout .scroll": "hideScrollBar"
