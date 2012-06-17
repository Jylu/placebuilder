Home.ui.Registration = Framework.View.extend
  template: "home.registration"

  events:
    "click .nav-tabs": "switchTab"
    "click .next1": "subscribe"

  render: (params) ->
    header = new Home.ui.RegistrationHeader el: $("header")
    header.render(params)
    $(".full-width").append this.renderTemplate(params)
    $(document).ready ->
      $("#full-name").focus()
      $(".drop").toggle(
        ->
          $('dropdown').css("opacity", "1")
        ->
          $('dropdown').css("opacity", "0")
      )

  switchTab: (e) ->
    e.preventDefault()
    $('.tab-content > div').hide().filter(this.hash).fadeIn("500","linear");
    $('ul.nav-tabs > a').removeClass('selected')
    $(e.currentTarget).addClass('selected')
    false

  subscribe: (e) ->
    e.preventDefault()
    page2 = new Home.ui.Subscribe(el: this.$("#registration_content"))
    page2.render()