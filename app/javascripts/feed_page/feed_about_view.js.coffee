CommonPlace.pages.PageAboutView = CommonPlace.View.extend(
  template: "feed_page/feed-about"
  id: "feed-about"
  about: ->
    @model.get "about"
)
