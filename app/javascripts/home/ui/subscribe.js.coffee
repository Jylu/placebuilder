Home.ui.Subscribe = Framework.View.extend
  template: "home.subscribe"

  #Business, Municipal, Organization, News, Personal, Discussion - kinds from template
  kinds: [
    "Non-profit",
    "Community Group",
    "Business",
    "Municipal",
    "News",
    "Other"
  ]

  render: () ->
    params = 
      "categories": @kinds
    this.$el.html this.renderTemplate(params)

    router.community.getAllPages
      success: (pages) =>
        pages.each (p) =>
          page = p.toJSON()
          page.about.trim()
          page.name.trim()
          page_view = new Home.ui.RegistrationPage({model: page})
          page_view.render(page)
          category = "#" + @kinds[page.kind]
          $(category).append(page_view.el)

