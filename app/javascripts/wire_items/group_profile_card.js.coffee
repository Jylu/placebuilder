CommonPlace.wire_item.GroupProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/group-card"
  tagName: "li"
  className: "wire-item"

  events:
    "click .subscribe-link": "subscribe"

  event_count: ->
    @model.get "events_count"

  subscribers: ->
    @model.get "subscribers_count"

  isSubscribed: ->
    CommonPlace.account.isSubscribedToGroup @model

  subscribe: (e) ->
    e.preventDefault() if e
    CommonPlace.account.subscribeToGroup @model, _.bind(->
      @render()
    , this)

  unsubscribe: (e) ->
    e.preventDefault() if e
    CommonPlace.account.unsubscribeFromGroup @model, _.bind(->
      @render()
    , this)
)
