CommonPlace.wire_item.GroupProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/group-card"
  tagName: "li"
  className: "wire-item"

  event_count: ->
    @model.get "events_count"

  subscribers: ->
    @model.get "subscribers_count"

  about: ->
    @model.get "about"
)
