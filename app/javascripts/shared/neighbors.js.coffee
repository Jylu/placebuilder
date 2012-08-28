CommonPlace.shared.Neighbors = CommonPlace.View.extend
  template: "shared.sidebar.neighbors"

  afterRender: () ->
    CommonPlace.community.users.fetch
      success: (neighbors) =>
        first = true
        neighbors.each (n) =>
          neighbor = n.toJSON()
          if neighbor.about isnt null
            neighbor.about.trim()
          html = this.renderTemplate("shared.sidebar.neighbor", neighbor)
          this.$(".list").append html
          if first
            $(".neighbor").addClass("first_neighbor")
            first = false




