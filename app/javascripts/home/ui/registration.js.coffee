Home.ui.Registration = Framework.View.extend
  template: "home.registration"
  reg_page: undefined
  pages: []
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
    @user_info =
      "isFacebook": false
    @community = window.location.pathname.split("/")[1]
    _.bindAll(this)

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

  showVerificationPage: (index) ->
    @pages[index] = new Home.ui.Verification(el: $("#registration_content"))
    params =
      "community": @community
      "referrers": @referrers
    @pages[index].render(params).animate({'margin-left' : '0px'}, 800)

  showWelcomePage: (index) ->
    @pages[index] = new Home.ui.Welcome(el: $("#registration_content"))
    params =
      "name": @user_info.full_name.split(" ")[0]
      "community": @community
    @pages[index].render(params).hide().animate({'margin-left' : '-800px'}, 10).show().animate({'margin-left' : '0px'}, 800)

  showProfilePage: (index) ->
    #Kevin - implement slide out here
    prev_page = index-1
    #if prev_page of @pages 
      #makes sure the previous page is in the array
      #@pages[prev_page].slideOut()
    @pages[index] = new Home.ui.civicProfile(el: $("#registration_content"))
    @pages[index].render(@user_info).hide().animate({'margin-left' : '-800px'}, 10).show().animate({'margin-left' : '0px'}, 800)

  nextPage: (e) ->
    if e
      e.preventDefault()
    @reg_page = if @reg_page is undefined then 2 else @reg_page + 1
    @prev_page = @reg_page-1
    switch this.reg_page
      when 2
        @user_info.full_name = this.$('.name').val()
        @user_info.email = this.$('.email').val()
        @user_info.password = this.$('.password').val()
       
        fields = ["full_name", "email"] 
        this.validate(@user_info, fields, this.showVerificationPage)
      when 3
        @user_info.address = this.$('input.address').val()
        referral = this.$(':selected').val()
        if referral is "default"
          alert "Please tell us how you heard about CommonPlace"
          @reg_page--
        else
          @user_info.referral_source = referral

          fields = ["address"]
          this.validate(@user_info, fields, this.showProfilePage)
      when 4
        #get the info from the profile page
        @user_info.about = this.$('#about').val()
        @user_info.status = this.$('#status').val()
        @user_info.goods = this.$('#goods').val()
        @user_info.skills = this.$('#skills').val()
        @user_info.interests = this.$('#interests').val()
        @user_info.organizations = this.$('#organizations').val()
        this.createUser()
      when 5
        @pages[@reg_page] = new Home.ui.Subscribe(el: $("#registration_content"))
        @pages[@reg_page].render()
      when 6
        this.subscribeToPages()
        @pages[@reg_page] = new Home.ui.findNeighbors(el: $("#registration_content"))
        params =
          "name": @user_info.full_name.split(" ")[0]
          "community": @community
        @pages[@reg_page].render(params).hide().animate({'margin-left' : '-800px'}, 10).show().animate({'margin-left' : '0px'}, 800)
      else
        @reg_page = 1
        router.navigate(router.community.get("slug") + "/home", {"trigger": true, "replace": true})

  validate: (info, fields, onSuccess) ->
    validate_api = "/api/registration/"+router.community.id+"/validate"
    $.getJSON(validate_api, info, _.bind((response) ->
      valid = true
      if not _.isEmpty(response.facebook)
        window.location.pathname = "/users/auth/facebook"
      else
        _.each(fields, _.bind((field) ->
          if not _.isEmpty(response[field])
            error_message = _.reduce(response[field], (a, b) ->
              a + "and" + b
            )
            alert error_message
            valid = false
        , this))

        if valid
          if onSuccess
            onSuccess(@reg_page)
        else
          @reg_page--
    , this))

  createUser: ->
    if @user_info.isFacebook
      create_user_api = "/api/registration/"+router.community.id+"/facebook"
    else
      create_user_api = "/api/registration/"+router.community.id+"/new"
    $.post(create_user_api, @user_info, _.bind((response) ->
      if response.success is true or response.id
        router.account = new Home.model.Account response
        this.showWelcomePage(@reg_page)
      else
        _.each(["full_name","email","address","password"], _.bind((field) ->
          if not _.isEmpty(response[field])
            error_message = _.reduce(response[field], (a, b) ->
              a + "and" + b
            )
            alert error_message
            valid = false
        , this))
        @reg_page--
        console.log "Error processing request: "
    , this))

  subscribeToPages: ->
    feeds = _.map(this.$("input[name=feeds_list]:checked"), (feed) ->
      return $(feed).val()
    )
    if not _.isEmpty(feeds)
      router.account.subscribeToFeed(feeds)

  events:
    "click .next-button": "nextPage"
