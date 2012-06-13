Home.model.Community = Backbone.Model.extend
  url: ->
    "/api/communities/" + this.get("slug")


  getNeighbors: (params) ->
    neighbors = new Backbone.Collection()
    neighbors.url = "/api" + this.get("links").users
    neighbors.fetch params


  getPosts: (params, category = "") ->
    posts = new Backbone.Collection()
    posts.url = "/api" + this.get("links").posts + "/" + category
    posts.fetch params

  getPageContent: (params, page = "") ->
    posts = new Backbone.Collection()
    posts.url = "/api/feeds/" + page + "/announcements"
    posts.fetch params

  getPage: (params, page = "") ->
    posts = new Backbone.Collection()
    posts.url = "/api/feeds/" + page
    posts.fetch params

