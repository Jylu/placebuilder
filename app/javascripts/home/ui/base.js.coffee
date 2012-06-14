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
          #this.model.set(response)
          #this.render()
          #need to figure out how to re-render the post
        )
      )
  
  isThanked: ->
    thanks = _.map(this.model.get("thanks"), (thank) ->
        thank.thanker
    _.include(thanks, router.account.get("name"))
    )
    if thanks.length is 0
      return false
    else
      return true 
