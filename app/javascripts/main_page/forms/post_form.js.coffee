CommonPlace.main.PostForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.post-form"
  className: "create-neighborhood-post post"
  category: "neighborhood"

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()
    
    user_category = @$("[name=categorize]").val()
    if user_category isnt undefined
      @category = user_category

    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()
      category: @category

    @sendPost CommonPlace.community.posts, data
    @remove()
)
