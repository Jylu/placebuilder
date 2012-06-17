Home.ui.Registration = Framework.View.extend
  template: "home.registration"

  render: (params) ->
    header = new Home.ui.RegistrationHeader el: $("header")
    header.render(params)
    $(".main").append this.renderTemplate(params)
    $("#next").on("click", this.subscribe)
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
    if e
      e.preventDefault()
    page2 = new Home.ui.Subscribe(el: $("#registration_content"))
    page2.render()

  events:
    "click .nav-tabs": "switchTab"
    "click button": "subscribe"
