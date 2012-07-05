Home.ui.WireItem = Framework.View.extend
 
  checkThanked: () ->
    if this.isThanked()
      this.markThanked()
 
  markThanked: () ->
    this.$(".thank").html("Thanked!")
    this.$(".thank").addClass("thanked-post")

  thank: (e) ->
    if e
      e.preventDefault()
    if not this.isThanked()
      this.markThanked()
      $.post("/api" + this.model.get("links").thank, _.bind(
        (response) ->
          _kmq.push(['record', 'Wire Engagement', {'Type': 'Thank'}]);
          this.model.set(response)
          this.render()
      ,this)
      )
  
  isThanked: ->
    thanks = _.map(this.model.get("thanks"), (thank) ->
        thank.thanker
    )
    _.include(thanks, router.account.get("name"))

  reply: (e) ->
    if e
      e.preventDefault()
    reply = this.$(".post-reply").val()
    data =
      "body" : reply
    if reply isnt undefined
      replies = new Backbone.Collection()
      replies.url = "/api" + this.model.get("links").replies
      replies.create data,
        success: _.bind(
          (response) ->
            replies = this.model.get("replies")
            replies.push(response.toJSON())
            this.render()
          , this)
      replies.trigger("sync")

  share: (e) ->
    if e
      e.preventDefault()
    community_name = router.community.get("slug")
    params =
        "share_url": "http://www.ourcommonplace.com"
        "header": "Share this post!"
        "message": "Share this post with more people!"
        "avatar_url": "http://localhost:3000/system/feeds/881/avatar/normal.jpeg"
        "item_name": "test"
        "community_name": community_name
        "model": this.model
    share = router.share(community_name, params)
    _kmq.push(['record', 'Wire Engagement', {'Type': 'Share'}]);
      
