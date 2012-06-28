Home.ui.Registration = Framework.View.extend
  template: "home.registration"
  reg_page: undefined
  referrers: [
    "Flyer at my door",
      "Someone knocked on my door",
      "In a meeting with the community organizer",
      "At a table or booth at an event",
      "In an email",
      "On Facebook or Twitter",
      "On another website",
      "In the news",
      "Word of mouth",
      "Other"
    ]

  initialize: ->
    @reg_page = 1
    @user_info = {}
    @community = window.location.pathname.split("/")[1]

  render: (params) ->
    this.$el.html this.renderTemplate(params)
    header = new Home.ui.RegistrationHeader el: $("header")
    header.render(params)

    tab_containers = $('.tab-content > div')
    tabs = $('ul.nav-tabs > a')
    $('ul.nav-tabs a').each(->
      if this.pathname is window.location.pathname
        tabs.push(this)
        tab_containers.push($(this.hash).get(0))
    )

    $(tabs).click(
      ->
        #hide all tabs
        $('.tab-content > div').hide().filter(this.hash).fadeIn("500","linear")

        #set up selected tab
        $(tabs).removeClass('selected')
        $(this).addClass('selected')
        return false
    )

  nextPage: (e) ->
    if e
      e.preventDefault()
    @reg_page = if @reg_page is undefined then 2 else @reg_page + 1
    switch this.reg_page
      when 2
        @user_info.name = this.$('.name').val()
        @user_info.email = this.$('.email').val()
        @user_info.password = this.$('.password').val()
        page2 = new Home.ui.Verification(el: $("#registration_content"))
        params =
          "community": @community
          "referrers": @referrers
        page2.render(params)
      when 3
        @user_info.address = this.$('input.address')
        referral = this.$(':selected').val()
        if referral is "default"
          alert "Please tell us how you heard about CommonPlace"
          @reg_page--
        else
          @user_info.referrer = referral
          page3 = new Home.ui.Welcome(el: $("#registration_content"))
          params =
            "name": @user_info.name.split(" ")[0]
            "community": @community
          page3.render(params)
      when 4
        page4 = new Home.ui.Subscribe(el: $("#registration_content"))
        page4.render()
      when 5
        page5 = new Home.ui.findNeighbors(el: $("#registration_content"))
        page5.render()
        this.reg_page = 1  #call this on the last registration page

  events:
    "click .next-button": "nextPage"
