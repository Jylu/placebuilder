Home.Router = Backbone.Router.extend
  routes:
    ":community/home" : "home"
    ":community/home/create-post": "createDefault"
    ":community/home/create-conversation": "createConvo"
    ":community/home/create-event": "createEvent"
    ":community/home/create-request": "createRequest"
    ":community/home/pages/:page": "showPage"

  home: (community)->
    header = new Home.ui.Header el: $("header")
    header.render(
      "H1": community.charAt(0).toUpperCase() + community.slice(1)
      "H2": "All Recent Posts"
    )

    sidebar = new Home.ui.Sidebar el: $("#sidebar")
    sidebar.render()

    content = new Home.ui.CommunityContent el: $("#content")
    content.render()

  showPage: (community, page) ->
    self = this
    groups = this.community.get("links").groups
    $.getJSON("/api/" + groups, (group) ->
      $.getJSON("/api/feeds/"+page, (response) ->
        page_feed = new Home.model.Page response

        page_view = new Home.ui.Page model: page_feed, community: self.community, account: self.account, name: page
        page_view.render()
      )
    )
    

  createPost: ->
    posting = new Home.ui.Posting()
    posting.render()
    modal = new Home.ui.Modal(el: $("#modal"), view: posting)
    modal.render()
    return posting

  createDefault: ->
    posting = this.createPost()
    posting.showDefault "default"

  createConvo: ->
    posting = this.createPost()
    posting.show "conversation"

  createEvent: ->
    posting = this.createPost()
    posting.show "event"

  createRequest: ->
    posting = this.createPost()
    posting.show "request"
