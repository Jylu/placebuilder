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

  # To Titi: It's funny that you should mention re-wiring the buy-link to point to the
  # messageUser function, because it seems like that's exactly what I already did.
  messageUser: (e) ->
    e.preventDefault()  if e
    unless @model.get("author_id") is CommonPlace.account.id
      params = { buyer: CommonPlace.account.id }
      $.post "/api" + @model.link("buy"), params, _.bind((response) ->
        subject = "Re: " + @model.get("title")
        # Re-route this to the payment/whatever-you-want-to-call-it-form
        # with appropriate variables
        # Upon re-reading the process outline, add logic to choose between
        # two different forms perhaps? [depending on single/multiple payment
        # options]
        @model.user (user) ->
          #formview = new PaymentFormView(model: new Payment(payable: user))
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
