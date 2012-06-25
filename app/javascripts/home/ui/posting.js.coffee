Home.ui.Posting = Framework.View.extend
  template: "home.posting"
  klass: "discussion"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    this.$("select.dk").dropkick()	
    this.$("input.date", this.el).datepicker dateFormat: "yy-mm-dd"

  remove: ->
    this.$(".form-container, .container").hide()

  show: (klass) ->
    this.klass = klass
    this.$(".general-help, .form-container, .links").hide()
    this.$("." + klass).show()
    this.$(".help." + klass + ".rounded_corners").hide()
    this.$(".links-" + klass).show()
    this.$(".links ." + klass).addClass "current"
    if klass is "share"
      this.$("#share_facebook").hide()
      this.$("#share_email").hide()
      this.$("#share_link").hide()
      this.$(".go-back").hide()
	
  showDefault: (klass) ->
    this.$(".go-back, .form-container").hide()
    this.$("." + klass).show()
    this.$(".links ." + klass).addClass "current"

  createPost: (e) ->
    e.preventDefault()
    title        = this.$("[name="+this.klass+"-title]").val()
    body         = this.$("[name="+this.klass+"-post]").val()
    price        = this.$("[name="+this.klass+"-price]").val()
    date         = this.$("[name="+this.klass+"-date]").val()
    starttime    = this.$("[name="+this.klass+"-starttime]").val()
    endtime      = this.$("[name="+this.klass+"-endtime]").val()
    venue        = this.$("[name="+this.klass+"-venue]").val()
    address      = this.$("[name="+this.klass+"-address]").val()
    category     = this.klass.toLowerCase()

    subcategory  = this.$("[name=topics]").val().toLowerCase()
    if subcategory is "default"
      subcategory = this.klass.toLowerCase()

    params = 
      "title"    : title
      "body"     : body
      "price"    : price
      "date"     : date
      "starttime": starttime
      "endtime"  : endtime
      "venue"    : venue
      "address"  : address
      "category" : category 
    this.sendPost(params)

  sendPost: (data) ->
    community = router.community 
    posts = new Backbone.Collection()
    posts.url = "/api" + community.get("links").posts
    posts.create data,
      success: (nextModel, resp) ->
        console.log("Sync triggered successfully. Next model is: #{nextModel} with a response of #{resp}")
        # put code in here to generate the public link of the post?
        # model.url? - http://localhost:3000/Marquette/show/posts/<id>
        # Have this code call the share modal? - router.share(community, params) ?
      error: (attribs, response) ->
        console.log("Error syncing:#{response} with attributes:#{attribs}")
        
    posts.trigger("sync")
    router.navigate(community.get("slug") + "/home/share", {"trigger": true, "replace": true})
    this.remove()

  events:
    "click .red-button": "createPost"
