Home.ui.RegistrationPage = Framework.View.extend
  template: "home.registration-page"
  tagName: "li"

  events:
    "click": "check"

  initialize: (options) ->
    this.model = options.model

  render: (params) ->
    this.$el.html this.renderTemplate(params)

  check: (e) ->
    if e
      e.preventDefault()

    checkbox = this.$("input[type=checkbox]")
    if checkbox.attr("checked")
      checkbox.attr("checked", false)
      this.$(".check").removeClass("checked")
    else
      checkbox.attr("checked", true)
      this.$(".check").addClass("checked")
      
