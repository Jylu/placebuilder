Home.ui.Registration = Framework.View.extend
  template: "home.registration"
  reg_page: undefined

  initialize: ->
    @reg_page = 1

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    header = new Home.ui.RegistrationHeader el: $("header")
    header.render(params)

  switchTab: (e) ->
    e.preventDefault()
    $('.tab-content > div').hide().filter(this.hash).fadeIn("500","linear");
    $('ul.nav-tabs > a').removeClass('selected')
    $(e.currentTarget).addClass('selected')
    false

  nextPage: (e) ->
    if e
      e.preventDefault()
    @reg_page = if @reg_page is undefined then 2 else @reg_page + 1
    switch this.reg_page
      when 2
        page2 = new Home.ui.Subscribe(el: $("#registration_content"))
        page2.render()
      when 3
        page3 = new Home.ui.findNeighbors(el: $("#registration_content"))
        page3.render()
        this.reg_page = 1  #call this on the last registration page

  events:
    "click .nav-tabs": "switchTab"
    "click .next-button": "nextPage"
