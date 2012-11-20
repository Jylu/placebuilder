CommonPlace.main.BaseForm = CommonPlace.View.extend(
  tagName: "form"
  className: "create-neighborhood-post post"
  category: "neighborhood"
  events:
    "click .submit": "createPost"
    "focusin input, textarea": "onFormFocus"
    "keydown textarea": "resetLayout"
    "focusout input, textarea": "onFormBlur"
    "click .close": "close"

  initialize: (options) ->
    if options
      @template = options.template or @template if options.template
      @category = options.category or @category if options.category

  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()

  close: (e) ->
    e.preventDefault()
    @remove()

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()
    
    # Category not specified
    if @options.category is `undefined`
      
      # Show a notification
      $(".error").html("Please select a category")
      $(".error").show()
      @$(".spinner").hide()
      @$("button").show()
    else
      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()
        category: @$("[name=categorize]").val()

      @sendPost CommonPlace.community.posts, data

  sendPost: (collection, data, callback) ->
    self = this
    collection.create data,
      success: _.bind((post) ->
        collection.trigger "sync"
        self.render()
        self.resetLayout()
        _kmq.push(['record', 'Post', {'Schema': post.get("schema"), 'ID': post.id}]) if _kmq?
        @showShareModal(post, "Thanks for posting!", "Share your post with your friends!")
        callback() if callback
      , this)

      error: (attribs, response) ->
        _kmq.push(['record', 'Post Error', {'Attributes': attribs}]) if _kmq?
        self.$(".spinner").hide()
        self.$("button").show()
        self.showError response

  showShareModal: (model, header, message) ->
    shareModal = new CommonPlace.views.ShareModal(
      model: model
    )
    shareModal.set_header header
    shareModal.set_message message
    shareModal.render()

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

  resetLayout: ->
    CommonPlace.layout.reset()

  hideLabel: (e) ->
    $("option.label", e.target).hide()
)
