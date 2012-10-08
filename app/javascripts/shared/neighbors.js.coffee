CommonPlace.shared.Neighbors = CommonPlace.View.extend
  template: "shared.sidebar.neighbors"

  afterRender: () ->
    CommonPlace.community.users.fetch
      success: (neighbors) =>
        neighbors.each (n) =>
          neighbor = n.toJSON()
          if neighbor.about isnt null
            neighbor.about.trim()
          html = this.renderTemplate("shared.sidebar.neighbor", neighbor)
          this.$(".list").append html




