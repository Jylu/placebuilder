CommonPlace.wire_item.UserWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/user-item"
  tagName: "li"
  className: "wire-item group-member"
  initialize: (options) ->
    @attr_accessible [ "first_name", "last_name", "avatar_url" ]

  afterRender: ->
    @model.on "change", @render, this

  events:
    "click button": "messageUser"
    mouseenter: "showProfile"

  messageUser: (e) ->
    e and e.preventDefault()
    formview = new MessageFormView(model: new Message(messagable: @model))
    formview.render()

  showProfile: (e) ->
    @options.showProfile @model
)
