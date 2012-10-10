CommonPlace.main.PostBox = CommonPlace.View.extend(
  template: "main_page.home-post-box"
  id: "post-box"
  events:
    "click .navigation li": "clickTab"

  afterRender: ->
    @temp = {}
    #@showTab("nothing");

  clickTab: (e) ->
    e.preventDefault()
    
    # DETERMINE WHAT TO DO WITH URLS WHEN WE CLICK
    @switchTab $(e.target).attr("data-tab"), e
    $("#first_post_tooltip").hide()

  switchTab: (tab, e) ->
    if @$("form input").length
      $title = @$("[name=title]")
      $body = @$("[name=body], [name=about]")
      @temp = {}
      @temp.title = $title.val()  unless $title.attr("placeholder") is $title.val()
      @temp.body = $body.val()  unless $body.attr("placeholder") is $body.val()
    @showTab tab, e

  absolutePosition: (element) ->
    curleft = curtop = 0
    if element.offsetParent
      loop
        curleft += element.offsetLeft
        curtop += element.offsetTop
        break unless element = element.offsetParent
    [curleft, curtop]

  showTab: (tab, e) ->
    view = undefined
    $("#invalid_post_tooltip").hide()
    @$("li.current").removeClass "current"
    tab = "publicity"  if tab is "announcement"
    tab = "group"  if tab is "group_post"
    @$("li." + tab).addClass "current"
    view = @tabs(tab)
    view.render()
    $("#modal").html view.el
    if @temp
      @$("form input[name=title]").val @temp.title
      @$("form textarea[name=body]").val @temp.body
      @$("form textarea[name=about]").val @temp.body
    @$("[placeholder]").placeholder()
    CommonPlace.layout.reset()
    @showWire tab
    if view.$el.height() + @absolutePosition(view.el)[1] > $(window).height()
      
      # Make the position fixed
      newHeight = $(window).height() - @absolutePosition(view.el)[1] - 20
      view.$el.css "height", "" + newHeight + "px"
      view.$el.css "width", view.$el.width() + 25 + "px"
      view.$el.css "overflow-y", "scroll"
      view.$el.css "overflow-x", "hidden"
    view.onFormFocus()  if view.onFormFocus

  tabs: (tab) ->
    view = undefined
    constant =
      nothing: ->
        new CommonPlace.main.PostForm()
      event: ->
        new EventForm()
      discussion: ->
        new CommonPlace.main.PostForm(
          category: "neighborhood"
          template: "main_page.forms.home-post-form"
        )
      request: ->
        new CommonPlace.main.PostForm(
          category: "offers"
          template: "main_page.forms.home-post-request-offer-form"
        )
      other: ->
        new CommonPlace.main.PostForm(
          category: "other"
          template: "main_page.forms.home-post-form"
        )
      meetup: ->
        new CommonPlace.main.PostForm(
          category: "meetup"
          template: "main_page.forms.home-post-meetup-form"
        )
    unless constant[tab]
      view = new AnnouncementForm(feed_id: tab.split("-").pop())
    else
      view = constant[tab]()
    view

  groups: ->
    CommonPlace.community.get "groups"

  showWire: (tab) ->
    unless tab is "nothing"
      tab = "announcements"  if tab.search("feed") > -1
      wire = $(".resources .sub-navigation." + tab)
      if wire.length
        offset = wire.offset().top
        $(window).scrollTo offset - parseInt($("#community-resources .sticky").css("top"))

  feeds: ->
    CommonPlace.account.get "feeds"
)
