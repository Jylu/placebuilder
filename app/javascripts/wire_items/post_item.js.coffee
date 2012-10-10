CommonPlace.wire_item.PostWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/post-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .editlink": "editPost"
    "click .thank-link": "thank"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"

  canEdit: ->
    CommonPlace.account.canEditPost @model

  editPost: (e) ->
    e.preventDefault()
    formview = new CommonPlace.main.PostForm(
      model: @model
      template: "shared/post-edit-form"
    )
    formview.render()
)
