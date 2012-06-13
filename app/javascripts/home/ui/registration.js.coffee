Home.ui.Registration = Framework.View.extend
  template: "home.registration"

  events:
    "click .nav-tabs": "switchTab"

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

