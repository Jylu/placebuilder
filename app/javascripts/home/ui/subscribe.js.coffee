Home.ui.Subscribe = Framework.View.extend
  template: "home.subscribe"

  render: () ->
    this.$el.html this.renderTemplate()

    router.community.getAllPages
      success: (pages) =>
        pages.each (p) =>
          page = p.toJSON()
          page.about.trim()
          page.name.trim()
          page_view = new Home.ui.RegistrationPage({model: page})
          page_view.render(page)
          $("ul.subscribe_pages").append(page_view.el)

