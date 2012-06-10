Home.ui.YourPages = Framework.View.extend
  template: "home.your-pages"

  render: (params) -> 
    #account = router.account
    #community = router.community
    #subscriptions = account.get("feed_subscriptions")
    #this.addFeedPageLink(feed_id) for feed_id in subscriptions
    
    this.$el.html this.renderTemplate(params)

  #addFeedPageLink: (feed_id) ->
  #  $.ajax '/api/feeds/'+feed_id,
  #    type: 'GET'
  #    dataType: 'json'
  #    error: (jqXHR, textStatus, errorThrown) ->
  #      alert "Unable to retrieve your pages: #{textStatus}"
  #    success: (data, textStatus, jqXHR) ->
  #      name = data.name
  #      url = data.url
  #      $('#your-pages-list').append "<li><a href='#{url}'>#{name}</a></li>"

