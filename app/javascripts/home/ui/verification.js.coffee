Home.ui.Verification = Framework.View.extend
  template: "home.verification"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    this.$("select.dk").dropkick()	

