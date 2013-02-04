CommonPlace.wire_item.UserProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/user-card"
  tagName: "li"
  className: "wire-item"

  post_count: ->
    @model.get "post_count"

  reply_count: ->
    @model.get "reply_count"

  sell_count: ->
    @model.get "sell_count"

  thank_count: ->
    @model.get "thank_count"

  met_count: ->
    @model.get "met_count"

  about: ->
    @model.get "about"
)
