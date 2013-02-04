CommonPlace.wire_item.ProfileCard = CommonPlace.View.extend(

  avatar: ->
    @model.get "avatar_url"

  name: ->
    @model.get "name"
)
