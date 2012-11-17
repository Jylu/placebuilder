CommonPlace.main.PostBox = FormView.extend(
  template: "main_page.post-box"
  id: "post-box"
  events:
    "click .navigation li": "clickTab"
    "click .close": "exit"

  clickTab: (e) ->
    e.preventDefault()
    
    # DETERMINE WHAT TO DO WITH URLS WHEN WE CLICK
    @switchTab $(e.currentTarget).attr("data-tab"), e
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
    $(".links").html view.el
    if @temp
      @$("form input[name=title]").val @temp.title
      @$("form textarea[name=body]").val @temp.body
      @$("form textarea[name=about]").val @temp.body
    @$("[placeholder]").placeholder()
    CommonPlace.layout.reset()
    if view.$el.height() + @absolutePosition(view.el)[1] > $(window).height()
      
      # Make the position fixed
      newHeight = $(window).height() - @absolutePosition(view.el)[1] - 20
      view.$el.css "height", "" + newHeight + "px"
      view.$el.css "width", view.$el.width() + 25 + "px"
      view.$el.css "overflow-y", "scroll"
      view.$el.css "overflow-x", "hidden"
    view.onFormFocus()  if view.onFormFocus
    $(".dropdown").chosen()
    #$(".chzn-select").chosen()
    $(".chzn-drop").css('width','413px')


  tabs: (tab) ->
    view = undefined
    constant =
      nothing: ->
        new CommonPlace.main.PostForm()
      event: ->
        new CommonPlace.main.EventForm()
      transaction: ->
        new CommonPlace.main.TransactionForm()
      discussion: ->
        new CommonPlace.main.PostForm(
          category: "neighborhood"
          template: "main_page.forms.post-form"
        )
      request: ->
        new CommonPlace.main.PostForm(
          category: "offers"
          template: "main_page.forms.post-offer-form"
        )
    unless constant[tab]
      view = new CommonPlace.main.AnnouncementForm(feed_id: tab.split("-").pop())
    else
      view = constant[tab]()
    view

  groups: ->
    CommonPlace.community.get "groups"

  feeds: ->
    CommonPlace.account.get "feeds"
)
