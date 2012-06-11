Home.ui.YourPages = Framework.View.extend
  template: "home.your-pages"

  render: (params) -> 
    account = router.account
    subscriptions = account.get("feed_subscriptions")
    this.addFeedPageLink(feed_id) for feed_id in subscriptions
    
    this.$el.html this.renderTemplate(params)

  addFeedPageLink: (feed_id) ->
    $.ajax '/api/feeds/'+feed_id,
      type: 'GET'
      dataType: 'json'
      success: (data, textStatus, jqXHR) ->
        name = data.name
        url = "/home"+data.url
        $('#your-pages-list').append "<li><a href='#{url}'>#{name}</a></li>"

