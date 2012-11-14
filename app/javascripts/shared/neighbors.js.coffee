CommonPlace.shared.Neighbors = CommonPlace.View.extend
  template: "shared.sidebar.neighbors"

  afterRender: () ->
    CommonPlace.account.featuredUsers.fetch
      success: (neighbors) =>
        neighbors.each (n) =>
          neighbor = n.toJSON()
          if neighbor.about isnt null
            neighbor.about.trim()
          neighbor.url = '/' + CommonPlace.community.get("slug") + '/show' + neighbor.url
          html = this.renderTemplate("shared.sidebar.neighbor", neighbor)
          this.$(".list").append html




