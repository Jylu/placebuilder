Home.ui.Page = Framework.View.extend
  template: "home.page"
  id: "page"

  initialize: (options) ->
    self = this
    this.community = options.community
    this.account = options.account
    this.model = options.model

    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": @community.get("name")
      "H2": options.name
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    postbox = new Home.ui.PagePosting el: $("#postbox"), model: this.model
    postbox.render()

