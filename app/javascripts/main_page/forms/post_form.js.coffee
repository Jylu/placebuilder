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
    collection = CommonPlace.community.posts
    if group_id isnt ""
      group = new Group({links: {self: "/groups/" + group_id, posts: "/groups/" + group_id + "/posts"}})
      collection = group.posts

    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()

    @sendPost collection, data

)
