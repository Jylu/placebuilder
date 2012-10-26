CommonPlace.wire_item.AnnouncementWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/announcement-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .editlink": "editAnnouncement"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"

  wireCategoryName: ->
    category = @wireCategory()
    if category
      category = (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
    else
      category = "Announcement"

  canEdit: ->
    CommonPlace.account.canEditAnnouncement @model

  editAnnouncement: (e) ->
    e.preventDefault()  if e
    formview = new CommonPlace.main.AnnouncementForm(
      model: @model
      template: "shared/announcement-edit-form"
    )
    formview.render()
)
