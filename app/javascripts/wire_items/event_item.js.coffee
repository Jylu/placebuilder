CommonPlace.wire_item.EventWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/event-item"
  tagName: "li"
  className: "wire-item"

  monthAbbrevs: [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sept", "Oct", "Nov", "Dec" ]

  events:
    "click .editlink": "editEvent"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"

  short_month_name: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    @monthAbbrevs[m[2] - 1]

  day_of_month: ->
    m = @model.get("occurs_on").match(/(\d{4})-(\d{2})-(\d{2})/)
    m[3]

  venue: ->
    @model.get "venue"

  address: ->
    @model.get "address"

  time: ->
    @model.get "starts_at"

  wireCategoryName: ->
    category = @wireCategory()
    if category
      category = (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
    else
      category = "Event"

  editEvent: (e) ->
    e and e.preventDefault()
    formview = new CommonPlace.main.EventForm(
      model: @model
      template: "shared/event-edit-form"
    )
    formview.render()

  canEdit: ->
    CommonPlace.account.canEditEvent @model
)
