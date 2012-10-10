CommonPlace.main.PostForm = CommonPlace.View.extend(
  template: "main_page.forms.home-post-form"
  tagName: "form"
  className: "create-neighborhood-post post"
  events:
    "click button": "createPost"
    "focusin input, textarea": "onFormFocus"
    "keydown textarea": "resetLayout"
    "focusin select": "hideLabel"
    "click select": "hideLabel"
    "focusout input, textarea": "onFormBlur"
    mouseenter: "mouseEnter"
    mouseleave: "mouseLeave"

  initialize: (options) ->
    @template = options.template or @template  if options

  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()

    # Category not specified
    if @options.category is `undefined`

      # Show a notification
      $("#invalid_post_tooltip").show()
      @$(".spinner").hide()
      @$("button").show()
    else
      @options.category = "publicity"  if $("input[name=commercial]").is(":checked")
      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()
        category: @$("[name=categorize]").val()

      @sendPost CommonPlace.community.posts, data
      @remove()

  sendPost: (postCollection, data) ->
    self = this
    postCollection.create data,
      success: ->
        postCollection.trigger "sync"
        self.render()
        self.resetLayout()

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

      CommonPlace.layout.reset()

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
)
