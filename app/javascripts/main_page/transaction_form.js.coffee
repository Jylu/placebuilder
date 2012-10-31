CommonPlace.main.TransactionForm = CommonPlace.View.extend(
  template: "main_page.forms.transaction-form"
  tagName: "form"
  className: "create-transaction transaction"
  events:
    "click button": "createTransaction"
    "keydown textarea": "resetLayout"
    "focusout input, textarea": "onFormBlur"
    "click .close": "close"

  afterRender: ->
    @data = {}
    @hasImageFile = false
    @$("input[placeholder], textarea[placeholder]").placeholder()
    @initImageUploader @$(".image_file_browser")
    self = this

  close: (e) ->
    e.preventDefault()
    @remove()

  initImageUploader: ($el) ->
    self = this
    @imageUploader = new AjaxUpload($el,
      action: "/api/transactions/image"
      name: "image"
      data: @data
      responseType: "json"
      autoSubmit: true
      onChange: ->
        @hasImageFile = true

      onSubmit: (file, extension) ->

      onComplete: _.bind((file, response) ->
          $(".item_pic").attr("src", response.image_url)
          @data.image_id = response.id
        , this)
    )

  createTransaction: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$("button").hide()
    @$(".spinner").show()

    number = @$("[name=price]").val()
    price = Number(number.replace(/[^0-9\.]+/g, "") * 100).toFixed(2)
    @data.title= @$("[name=title]").val()
    @data.price= price
    @data.body= @$("[name=body]").val()

    @sendTransaction CommonPlace.community.transactions, @data
    @remove()

  sendTransaction: (transactionCollection, data) ->
    self = this
    transactionCollection.create data,
      success: (response) ->
        CommonPlace.community.transactions.trigger "sync"
        if self.hasImageFile
          self.imageUploader.submit()

        $.ajax(
          type: "POST"
          url: "/api" + response.get("links").self + "/add_image"
          data:
            "image_id" : response.get("image_id")
          success: (response) ->
          dataType: "JSON"
        )
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
