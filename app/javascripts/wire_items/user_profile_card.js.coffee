CommonPlace.wire_item.UserProfileCard = CommonPlace.wire_item.ProfileCard.extend(
  template: "wire_items/user-card"
  tagName: "li"
  className: "wire-item"

  events:
    "click .message-link": "messageUser"
    "click .meet": "meet"
    "click .unmeet": "unmeet"

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

  hasOrganizations: ->
    o = @model.get "organizations"

    return true if o && o.length != 0

    false

  organizations: ->
    organizations = @model.get "organizations"
    o = organizations.replace(/\n/g, ", ")
    return o

  pages: ->
    @model.get "pages"

  hasMet: () ->
    CommonPlace.account.hasMetUser @model

  meet: (e) ->
    e.preventDefault() if e
    CommonPlace.account.meetUser @model
    @$(".just-met").show()
    @$(".meet").hide()
    _kmq.push(['record', 'Met User', {'initiator': CommonPlace.account.id, 'recipient': @model.id}]) if _kmq?

  unmeet: (e) ->
    CommonPlace.account.unmeetUser @model, _.bind(->
      @render()
    , this)
)
