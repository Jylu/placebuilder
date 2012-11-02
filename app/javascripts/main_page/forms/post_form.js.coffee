CommonPlace.main.PostForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.post-form"
  className: "create-neighborhood-post post"

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
      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()
        category: @$("[name=categorize]").val()

      @sendPost CommonPlace.community.posts, data
      @remove()
)
