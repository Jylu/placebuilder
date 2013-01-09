CommonPlace.shared.YourTown = CommonPlace.View.extend
  template: "shared.sidebar.your-town"
  id      : "your-town"

  events:
    "click a": "loadWire"

  loadWire: (e) ->
    e.preventDefault() if e
    page = @$(e.currentTarget).attr("id")
    app.communityWire(CommonPlace.community.get("slug"), page)
