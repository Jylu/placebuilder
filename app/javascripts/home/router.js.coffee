Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"
    ":community/home/create-post": "createDefault"
    ":community/home/create-conversation": "createDiscussion"
    ":community/home/create-event": "createEvents"
    ":community/home/create-request": "createRequests"
    ":community/home/create-meetup": "createMeetups"
    ":community/home/share": "createShare"

  content: undefined

  home: ->
    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": "Herp Derp"
      "H2": "All Recent Posts"
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    if this.content is undefined
      this.content = new Home.ui.CommunityContent el: $("#content")
    this.content.render()

  createPost: (community) ->
    posting = new Home.ui.Posting()
    posting.render(
      "create-post-link": "/" + community + "/home/create-post"
    )
    modal = new Home.ui.Modal(el: $("#modal"), view: posting)
    modal.render()
    return posting

  createDefault: (community) ->
    posting = this.createPost(community)
    posting.showDefault "default"

  createDiscussion: (community) ->
    posting = this.createPost(community)
    posting.show "discussion"

  createRequests: (community) ->
    posting = this.createPost(community)
    posting.show "request"

  createEvents: (community) ->
    posting = this.createPost(community)
    posting.show "event"

  createMeetups: (community) ->
    posting = this.createPost(community)
    posting.show "meetup"

  createShare: (community) ->
    posting = this.createPost(community)
    posting.show "share"
