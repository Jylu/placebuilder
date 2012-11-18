CommonPlace.main.PostForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.post-form"
  className: "create-neighborhood-post post"

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
    if group_id isnt undefined
      group = new Group({links: {self: "/groups/" + group_id, posts: "/groups/" + group_id + "/posts"}})
      collection = group.posts

    data =
      title: @$("[name=title]").val()
      body: @$("[name=body]").val()

    if @category isnt undefined
      data['category'] = @category

    @sendPost collection, data

)
