Home.ui.YourTown = Framework.View.extend
  template: "home.your-town"

  render: () ->
    this.$el.html this.renderTemplate()

  showPosts: (e) ->
    e.preventDefault()
    category = this.$(e.currentTarget).attr("id")
    content = router.content
    if content isnt undefined
      content.render(category)
    $(window).scroll(() =>
      this.updateHeader()
    )

  updateHeader: () ->
    $(".wire").each(() ->
      if($(this).offset().top < $(window).scrollTop())
        $("h2").html($(this).find(".wire-top").attr("data-time-ago"))
    )
    ###
    # this code smooths the multi-column ui
    # however, it should not be placed here
    # it needs to fire immediately after the content renders
    () ->
    container = $("#content").find(".list")
    container.imagesLoaded( () ->
      container.masonry({
        containerStyle: 'margin: 0 auto',
        itemSelector: '.wire',
        isFitWidth: true,
        isResizable: true
        #columnWidth: 350
      })
    )###

  events:
    "click a" : "showPosts"
