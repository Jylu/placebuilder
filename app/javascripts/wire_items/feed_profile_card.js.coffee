CommonPlace.wire_item.FeedProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/feed-card"
  tagName: "li"
  className: "wire-item"

  site_url: ->
    @model.get "website"

  announce_count: ->
    @model.get "announcements_count"

  event_count: ->
    @model.get "events_count"

  subscribers: ->
    @model.get "subscribers_count"

  about: ->
    @model.get "about"
)
