Home.ui.Verification = Framework.View.extend
  template: "home.verification"

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    this.$("select.dk").dropkick()

    url = '/api/communities/'+router.community.id+'/address_completions'
    this.$("input[class=address]").autocomplete({ source: url, minLength: 1})
