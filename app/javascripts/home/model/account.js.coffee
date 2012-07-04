Home.model.Account = Backbone.Model.extend
  url: "/api/account"

  subscribeToFeed: (feed, callback) ->
    feed_ids = if _.isArray(feed) then feed else feed.id
    self = this
    $.ajax(
      contentType: "application/json"
      url: "/api" + this.get("links").feed_subscriptions
      data: JSON.stringify({ id: feed_ids})
      type: "post"
      dataType: "json"
      success: (account) ->
        self.set(account)
        if callback
          callback()
    )
    
