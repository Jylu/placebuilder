CommonPlace.main.TransactionForm = CommonPlace.View.extend(
  template: "main_page.forms.transaction-form"
  tagName: "form"
  className: "create-transaction transaction"
  events:
    "click button": "createTransaction"
    "keydown textarea": "resetLayout"
    "focusout input, textarea": "onFormBlur"

  afterRender: ->
    @$("input[placeholder], textarea[placeholder]").placeholder()
    self = this

  createTransaction: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$("button").hide()
    @$(".spinner").show()

    number = @$("[name=price]").val()
    price = Number(number.replace(/[^0-9\.]+/g, "") * 100).toFixed(2)
    data =
      title: @$("[name=title]").val()
      price: price
      body: @$("[name=body]").val()

    @sendTransaction CommonPlace.community.transactions, data
    @remove()

  sendTransaction: (transactionCollection, data) ->
    self = this
    transactionCollection.create data,
      success: ->
        CommonPlace.community.transactions.trigger "sync"
        self.render()

      error: (attribs, response) ->
        self.$("button").show()
        self.$(".spinner").hide()
        self.showError response

  showError: (response) ->
    @$(".error").text response.responseText
    @$(".error").show()

  resetLayout: ->
    CommonPlace.layout.reset()

  onFormBlur: (e) ->
    if not $(e.target).val() or $(e.target).val() is $(e.target).attr("placeholder")
      $(e.target).removeClass "filled"
    else
      $(e.target).addClass "filled"
)
