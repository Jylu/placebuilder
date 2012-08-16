CommonPlace.pages.PageNavView = CommonPlace.View.extend(
  template: "feed_page/feed-nav"
  id: "feed-nav"
  events:
    "click a": "navigate"

  initialize: (options) ->
    @current = options.current or "showAnnouncements"
    @switchTab = options.switchTab

  navigate: (e) ->
    e.preventDefault()
    @current = $(e.target).attr("data-tab")
    @switchTab @current
    @render()

  classIfCurrent: ->
    self = this
    (text) ->
      (if @current is text then "current" else "")
)
