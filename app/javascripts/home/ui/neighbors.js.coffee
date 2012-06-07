Home.ui.Neighbors = Framework.View.extend
  template: "home.neighbors"

  render: (params) ->
    this.$el.html this.renderTemplate(params)

    router.community.getNeighbors
      data: { limit: 3 }
      success: (neighbors) =>
        neighbors.each (n) =>
          html = this.renderTemplate("home.neighbors.neighbor", n.toJSON())
          this.$(".list").append html




