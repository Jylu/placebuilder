CommonPlace.main.AnnouncementForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.announcement-form"
  className: "create-announcement post"

  aroundRender: (render) ->
    self = this
    $.getJSON "/api/feeds/" + @options.feed_id, (response) ->
      self.feed = new Feed(response)
      render()

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()
    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()

    @sendPost @feed.announcements, data

  name: ->
    @feed.get "name"
)
