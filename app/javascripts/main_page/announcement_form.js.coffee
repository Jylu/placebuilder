CommonPlace.main.AnnouncementForm = CommonPlace.View.extend(
  template: "main_page.forms.announcement-form"
  tagName: "form"
  className: "create-announcement post"
  events:
    "click button": "createPost"
    "focusin input, textarea": "onFormFocus"
    "keydown textarea": "resetLayout"
    "focusin select": "hideLabel"
    "click select": "hideLabel"
    "focusout input, textarea": "onFormBlur"
    "click .close": "close"
    mouseenter: "mouseEnter"
    mouseleave: "mouseLeave"

  aroundRender: (render) ->
    self = this
    $.getJSON "/api/feeds/" + @options.feed_id, (response) ->
      self.feed = new Feed(response)
      render()


  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()

  close: (e) ->
    e.preventDefault()
    @remove()

  #this.$("textarea").autoResize();
  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()
    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()

    @sendPost @feed.announcements, data

  sendPost: (postCollection, data) ->
    self = this
    postCollection.create data,
      success: ->
        self.render()
        self.resetLayout()
        CommonPlace.community.announcements.trigger "sync"

      error: (attribs, response) ->
        self.$(".spinner").hide()
        self.$("button").show()
        self.showError response


  showError: (response) ->
    @$(".error").text response.responseText
    @$(".error").show()

  onFormFocus: ->
    $moreInputs = @$(".on-focus")
    unless $moreInputs.is(":visible")
      naturalHeight = $moreInputs.actual("height")
      $moreInputs.css height: 0
      $moreInputs.show()
      
      #$moreInputs.animate(
      #{ height: naturalHeight },
      #{
      #  complete: function() { 
      #    $moreInputs.css({height: "auto"}); 
      #    CommonPlace.layout.reset();
      #  }, 
      #  step: function() {
      #    CommonPlace.layout.reset();
      #  }
      #}
      #);
      CommonPlace.layout.reset()

  
  #CommonPlace.account.clicked_post_box(function() {
  #  $("#invalid_post_tooltip").show();
  #});
  onFormBlur: (e) ->
    $("#invalid_post_tooltip").hide()
    unless @focused
      @$(".on-focus").hide()
      @resetLayout()
    if not $(e.target).val() or $(e.target).val() is $(e.target).attr("placeholder")
      $(e.target).removeClass "filled"
    else
      $(e.target).addClass "filled"

  mouseEnter: ->
    @focused = true

  mouseLeave: ->
    @focused = false

  resetLayout: ->
    CommonPlace.layout.reset()

  hideLabel: (e) ->
    $("option.label", e.target).hide()

  name: ->
    @feed.get "name"
)
