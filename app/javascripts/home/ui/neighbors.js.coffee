Home.ui.Neighbors = Framework.View.extend
  template: "home.neighbors"

  render: (params) ->
    this.$el.html this.renderTemplate(params)

    router.community.getNeighbors
      success: (neighbors) =>
        neighbors.each (n) =>
          neighbor = n.toJSON()
          if neighbor.about isnt null
            neighbor.about.trim()
          html = this.renderTemplate("home.neighbor", neighbor)
          this.$(".list").append html




