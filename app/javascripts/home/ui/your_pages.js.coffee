Home.ui.YourPages = Framework.View.extend
  template: "home.your-pages"

  render: -> 
    account = router.account
    community = router.community
    subscriptions = account.get("feed_subscriptions")
    this.addFeedPageLink(feed_id) for feed_id in subscriptions
    
    this.$el.html this.renderTemplate()

  addFeedPageLink: (feed_id) ->
    $.ajax '/api/feeds/'+feed_id,
      type: 'GET'
      dataType: 'json'
      error: (jqXHR, textStatus, errorThrown) ->
        alert "Unable to retrieve your pages: #{textStatus}"
      success: (data, textStatus, jqXHR) ->
        name = data.name
        url = data.url
        count = 42
        $('#your-pages-list').append "<li><a href='#{url}'>#{name}<span class='number-of'> (#{count})</span></a></li>"

