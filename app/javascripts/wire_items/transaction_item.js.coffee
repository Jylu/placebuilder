CommonPlace.wire_item.TransactionWireItem = CommonPlace.wire_item.WireItem.extend(
  template: "wire_items/transaction-item"
  tagName: "li"
  className: "wire-item"

  events:
    "click .buy-link": "messageUser"
    "click .editlink": "editTransaction"
    "click .thank-link": "thank"
    "click .flag-link": "flag"
    "click .share-link": "share"
    "click .reply-link": "reply"
    blur: "removeFocus"

  afterRender: ->
    @model.on "change", @render, this

  price: ->
    @format @model.get("price")

  format: (cents) ->
    "$" + (cents / 100.0).toFixed(2).toLocaleString()

  messageUser: (e) ->
    e.preventDefault()  if e
    unless @model.get("author_id") is CommonPlace.account.id
      params = { buyer: CommonPlace.account.id }
      $.post "/api" + @model.link("buy"), params, _.bind((response) ->
        subject = "Re: " + @model.get("title")
        @model.user (user) ->
          formview = new MessageFormView(model: new Message(messagable: user), subject: subject)
          formview.render()
      , this)

  wireCategoryName: ->
    category = @wireCategory()
    if category
      category = (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join(' ')
    else
      category = "For Sale"

  canEdit: ->
    CommonPlace.account.canEditTransaction @model

  editTransaction: (e) ->
    e.preventDefault()
    formview = new CommonPlace.main.TransactionForm(
      model: @model
      template: "shared/transaction-edit-form"
    )
    formview.render()
)
