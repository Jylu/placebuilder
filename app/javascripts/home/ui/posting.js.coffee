Home.ui.Posting = Framework.View.extend
  template: "home.posting"
  klass: "conversation"
  category: "Conversation"

  initialize: ->
    this.$(document).ready(
      -> $('[class*="scroll-pane"]').jScrollPane()
    )

  render: ->
    this.$el.html this.renderTemplate()

  remove: ->
    this.$(".navigation, .form-container, .container").hide()

  show: (klass) ->
    this.klass = klass
    this.$(".general-help, .form-container, .links").hide()
    this.$("." + klass).show()
    this.$(".help." + klass + ".rounded_corners").hide()
    this.$(".links-" + klass).show()
    this.$(".links ." + klass).addClass "current"

  showDefault: (klass) ->
    this.$(".go-back, .form-container").hide()
    this.$("." + klass).show()
    this.$(".links ." + klass).addClass "current"

  createPost: (e) ->
    e.preventDefault()
    title     = this.$("[name="+this.klass+"-title]").val()
    body      = this.$("[name="+this.klass+"-post]").val()
    price     = this.$("[name="+this.klass+"-price]").val()
    date      = this.$("[name="+this.klass+"-date]").val()
    starttime = this.$("[name="+this.klass+"-starttime]").val()
    endtime   = this.$("[name="+this.klass+"-endtime]").val()
    venue     = this.$("[name="+this.klass+"-venue]").val()
    address   = this.$("[name="+this.klass+"-address]").val()
    category  = this.category

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
      error: (attribs, response) ->
        console.log("Error syncing:#{response} with attributes:#{attribs}")
        
    posts.trigger("sync")
    router.navigate(community.get("slug") + "/home", {"trigger": true, "replace": true})
    this.remove()

  changeCategory: ->
    category = this.$("[name='category']:checked")
    this.category = category.val()
    klass = category.parent().attr("class")
    if klass isnt undefined
      this.show(klass)

  events:
    "click button": "createPost"
    "click .links-conversation li": "changeCategory"
    "click .links-request li": "changeCategory" 
    "click .links-event li": "changeCategory" 
