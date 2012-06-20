Home.ui.Registration = Framework.View.extend
  template: "home.registration"
  reg_page: undefined

  initialize: ->
    @reg_page = 3 #this should start at 1, changed to 3 temporarily for demo

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
        page2 = new Home.ui.Verification(el: $("#registration_content"))
        page2.render()
      when 3
        page3 = new Home.ui.Welcome(el: $("#registration_content"))
        page3.render()
      when 4
        page4 = new Home.ui.Subscribe(el: $("#registration_content"))
        page4.render()
      when 5
        page5 = new Home.ui.findNeighbors(el: $("#registration_content"))
        page5.render()
        this.reg_page = 1  #call this on the last registration page

  events:
    "click .next-button": "nextPage"
