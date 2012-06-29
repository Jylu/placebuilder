Home.ui.Subscribe = Framework.View.extend
  template: "home.subscribe"

  render: () ->
    this.$el.html this.renderTemplate()

    router.community.getAllPages
      success: (pages) =>
        pages.each (p) =>
          page = p.toJSON()
          this.$(".subscribe_pages").append("<li><a href='#'><img src='"+page.avatar_url+"' class='page_img'><h4>"+page.name.trim()+"</h4><span class='page_text'>"+page.about.trim()+"</span></a></li>")
        

