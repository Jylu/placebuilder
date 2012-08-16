CommonPlace.pages.PageActionsView = CommonPlace.View.extend(
  id: "feed-actions"
  template: "feed_page/feed-actions"
  events:
    "click #feed-action-nav a": "navigate"
    "click .post-announcement button": "postAnnouncement"
    "click .post-event button": "postEvent"
    "click .invite-subscribers form.invite-by-email button": "inviteByEmail"
    "change .post-label-selector input": "toggleCheckboxLIClass"

  initialize: (options) ->
    @feed = options.feed
    @groups = options.groups
    @account = options.account
    @community = options.community
    @postAnnouncementClass = "current"

  afterRender: ->
    @$("input.date").datepicker dateFormat: "yy-mm-dd"
    @$("input[placeholder], textarea[placeholder]").placeholder()
    
    #this.$("textarea").autoResize();
    @$("select.time").dropkick()

  navigate: (e) ->
    $target = $(e.target)
    $target.addClass("current").siblings().removeClass "current"
    $(@el).children(".tab").removeClass("current").filter("." + $target.attr("href").split("#")[1].slice(1)).addClass "current"
    @$(".error").hide()
    e.preventDefault()

  toggleCheckboxLIClass: (e) ->
    $(e.target).closest("li").toggleClass "checked"

  showError: (response) ->
    @$(".error").text response.responseText
    @$(".error").show()

  postAnnouncement: (e) ->
    $form = @$(".post-announcement form")
    self = this
    @cleanUpPlaceholders()
    e.preventDefault()
    @feed.announcements.create
      title: $("[name=title]", $form).val()
      body: $("[name=body]", $form).val()
      groups: $("[name=groups]:checked", $form).map(->
        $(this).val()
      ).toArray()
    ,
      success: ->
        self.render()

      error: (attribs, response) ->
        self.showError response


  postEvent: (e) ->
    self = this
    $form = @$(".post-event form")
    e.preventDefault()
    @cleanUpPlaceholders()
    @feed.events.create
      title: $("[name=title]", $form).val()
      about: $("[name=about]", $form).val()
      date: $("[name=date]", $form).val()
      start: $("[name=start]", $form).val()
      end: $("[name=end]", $form).val()
      venue: $("[name=venue]", $form).val()
      address: $("[name=address]", $form).val()
      tags: $("[name=tags]", $form).val()
      groups: $("[name=groups]:checked", $form).map(->
        $(this).val()
      ).toArray()
    ,
      success: ->
        self.render()

      error: (attribs, response) ->
        self.showError response


  avatarUrl: ->
    @feed.get("links").avatar.thumb

  time_values: _.flatten(_.map(["AM", "PM"], (half) ->
    _.map [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], (hour) ->
      _.map ["00", "30"], (minute) ->
        String(hour) + ":" + minute + " " + half
  ))

  inviteByEmail: (e) ->
    self = this
    $form = @$(".invite-subscribers form")
    e.preventDefault()
    $.ajax
      contentType: "application/json"
      url: "/api" + @feed.link("invites")
      data: JSON.stringify(
        emails: _.map($("[name=emails]", $form).val().split(/,|;/), (s) ->
          s.replace /\s*/, ""
        )
        message: $("[name=message]", $form).val()
      )
      type: "post"
      dataType: "json"
      success: ->
        self.render()

)
