Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"
    ":community/home/create-post": "createDefault"
    ":community/home/create-conversation": "createDiscussion"
    ":community/home/create-event": "createEvents"
    ":community/home/create-request": "createRequests"
    ":community/home/share": "createShare"

  home: ->
    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": "Herp Derp"
      "H2": "All Recent Posts"
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    content = new Home.ui.CommunityContent el: $("#content")
    content.render()

  createPost: ->
    posting = new Home.ui.Posting()
    posting.render()
    modal = new Home.ui.Modal(el: $("#modal"), view: posting)
    modal.render()
    return posting

  createDefault: ->
    posting = this.createPost()
    posting.showDefault "default"

  createDiscussion: ->
    posting = this.createPost()
    posting.show "discussion"

  createRequests: ->
    posting = this.createPost()
    posting.show "requests"

  createEvents: ->
    posting = this.createPost()
    posting.show "events"

  createShare: ->
    posting = this.createPost()
    posting.show "share"
