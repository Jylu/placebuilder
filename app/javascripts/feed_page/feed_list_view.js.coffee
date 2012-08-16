CommonPlace.pages.PageListView = CommonPlace.View.extend(
  template: "feed_page/feeds-list"
  feeds: ->
    CommonPlace.pages.feeds

  afterRender: ->
    height = 0
    $("#feeds-list li").each (index) ->
      return false  if index is 9
      height = height + $(this).outerHeight(true)

    $("#feeds-list ul").height height

  select: (slug) ->
    @$("li").removeClass "current"
    @$("li[data-feed-slug='" + slug + "']").addClass "current"
)
