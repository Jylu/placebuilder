Home.ui.PagePosting = Framework.View.extend
  template: "home.page-posting"

  className: "posting"

  initialize: (options) ->
    this.model = options.model

  render: ->
    this.$el.html this.renderTemplate()

  createPost: (e) ->
    e.preventDefault()
    title     = this.$("[name=title]").val()
    body      = this.$("[name=post]").val()
    category  = this.category

    params = 
      "title"    : title
      "body"     : body
      "category" : category 
    this.sendPost(params)

  sendPost: (data) ->
    self = this
    #pages = this.model #uncomment when server issue is fixed
    pages = new Backbone.Collection()
    pages.url = "/api"+this.model.get("links").announcements
    
    pages.create(data,
      success: ->
        self.render()
      error: (attrib, response) ->
        self.showError(response)
    )
    self.render()

  showError: (response) ->
    this.$(".error").text(response.responseText);
    this.$(".error").show()

  events:
    "click button": "createPost"
