CommonPlace.main.PostForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.post-form"
  className: "create-neighborhood-post post"
  category: "neighborhood"

  initialize: (options) ->
    CommonPlace.main.BaseForm.prototype.initialize options
    @groups = CommonPlace.community.get("groups")

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$(".spinner").show()
    @$("button").hide()
    
    group_id = @$("[name=group_selector]").val()
    if group_id is ""
      # Show an error
      $("#invalid_post_tooltip").show()
      @$("button").show()
    else
      @group_id = group_id

      data =
        title: @$("[name=title]").val()
        body: @$("[name=body]").val()

      group = new Group({links: {self: "/groups/" + @group_id, posts: "/groups/" + @group_id + "/posts"}})

      @sendPost group.posts, data
      @remove()

)
