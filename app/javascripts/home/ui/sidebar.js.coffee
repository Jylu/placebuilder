Home.ui.Sidebar = Framework.View.extend
  template          : "home.sidebar"
  links_header_class: "sidebar-links"

  render: ->
    this.$el.html this.renderTemplate()

    neighbors_params = 
      "title"       : "Your Neighbors"
      "header_class": this.links_header_class
      "links_id"    : "your-neighbors-links"

    pages_params = 
      "title"       : "Your Pages"
      "header_class": this.links_header_class
      "links_id"    : "your-pages-links"

    this.neighbors = new Home.ui.Neighbors(el: this.$("#directory_content"))
    this.neighbors.render(neighbors_params)

    #this.yourPages = new Home.ui.YourPages(el: this.$("#directory_content"))
    #this.yourPages.render(pages_params)

    this.yourTown = new Home.ui.YourTown(el: this.$("#your-town"))
    this.yourTown.render()

  toggleLinks: (e) ->
    e.preventDefault()
    this.$("#"+e.currentTarget.title).toggle()

  events:
    "click .sidebar-links": "toggleLinks"
