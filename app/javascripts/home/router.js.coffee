Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"
    ":community/home/register" : "register"
    ":community/home/create-post": "createDefault"
    ":community/home/create-conversation": "createDiscussion"
    ":community/home/create-event": "createEvents"
    ":community/home/create-request": "createRequests"
    ":community/home/create-meetup": "createMeetups"
    ":community/home/share": "createShare"
    ":community/home/pages/:page": "showPage"

  content: undefined

  home: (community) ->
    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": (community.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
      "H2": "All Recent Posts"
      "home_link": "/"+router.community.get("slug")+"/home"
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    this.createContent()
    this.content.render("home")

  register: (community) ->
    registration = new Home.ui.Registration el:$("#content")
    registration.render(
      "community": (community.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
    )

  showPage: (community, page) ->
    self = this
    # todo: make sure image exists before setting it; let redesign/bg.jpg remain default
    $("html").css("background-image", "url('/assets/shared/redesign/pages/" + community + "/" + page + ".jpg')")

    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": community.split(/[\s-_]+/).map((word) -> (word[0].toUpperCase() + word[1..-1].toLowerCase())).join ' '
      "H2": page.split(/[\s-_]+/).map((word) -> (word[0].toUpperCase() + word[1..-1].toLowerCase())).join ' '
      "home_link": "/"+router.community.get("slug")+"/home"
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    this.createContent()
    this.content.render("page", page)

  createContent: ->
    if this.content is undefined
      this.content = new Home.ui.CommunityContent el: $("#content")

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
