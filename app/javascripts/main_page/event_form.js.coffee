CommonPlace.main.EventForm = CommonPlace.View.extend(
  template: "main_page.forms.event-form"
  tagName: "form"
  className: "create-event event"
  events:
    "click button": "createEvent"
    "change .post-label-selector input": "toggleCheckboxLIClass"
    "keydown textarea": "resetLayout"
    "focusout input, textarea": "onFormBlur"
    "click .close": "close"

  afterRender: ->
    @$("input.date", @el).datepicker dateFormat: "yy-mm-dd"
    @$("input[placeholder], textarea[placeholder]").placeholder()
    
    #this.$("textarea").autoResize({});
    @$("select.time").dropkick()
    self = this
    @$("input.date").bind "change", ->
      self.onFormBlur target: self.$("input.date")

  close: (e) ->
    e.preventDefault()
    @remove()

  createEvent: (e) ->
    e.preventDefault()
    @$("button").hide()
    @$(".spinner").show()
    self = this
    @cleanUpPlaceholders()
    CommonPlace.community.events.create # use $.fn.serialize here
      title: @$("[name=title]").val()
      about: @$("[name=about]").val()
      date: @$("[name=date]").val()
      start: @$("[name=start]").val()
      end: @$("[name=end]").val()
      venue: @$("[name=venue]").val()
      address: @$("[name=address]").val()
      tags: @$("[name=tags]").val()
      groups: @$("[name=groups]:checked").map(->
        $(this).val()
      ).toArray()
    ,
      success: ->
        CommonPlace.community.events.trigger "sync"
        self.render()

      error: (attribs, response) ->
        self.$("button").show()
        self.$(".spinner").hide()
        self.showError response


  showError: (response) ->
    @$(".error").text response.responseText
    @$(".error").show()

  groups: ->
    CommonPlace.community.get "groups"

  toggleCheckboxLIClass: (e) ->
    $(e.target).closest("li").toggleClass "checked"

  resetLayout: ->
    CommonPlace.layout.reset()

  time_values: _.flatten(_.map(["AM", "PM"], (half) ->
    _.map [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], (hour) ->
      _.map ["00", "30"], (minute) ->
        String(hour) + ":" + minute + " " + half


  ))
  onFormBlur: (e) ->
    if not $(e.target).val() or $(e.target).val() is $(e.target).attr("placeholder")
      $(e.target).removeClass "filled"
    else
      $(e.target).addClass "filled"
)
