CommonPlace.main.TransactionForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.transaction-form"
  className: "create-transaction transaction"

  events:
    "click #ach": "acceptACH"

  afterRender: ->
    @data = {}
    @hasImageFile = false
    @$("input[placeholder], textarea[placeholder]").placeholder()
    @initImageUploader @$(".image_file_browser")
    self = this

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

  # Open another form...?
  acceptACH: (e) ->

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @$("button").hide()
    @$(".spinner").show()

    number = @$("[name=price]").val()
    price = Number(number.replace(/[^0-9\.]+/g, "") * 100).toFixed(2)
    @data.title= @$("[name=title]").val()
    @data.price= price
    @data.body= @$("[name=body]").val()

    @sendPost CommonPlace.community.transactions, @data

  sendPost: (transactionCollection, data) ->
    self = this
    transactionCollection.create data,
      success: _.bind((post) ->
        _kmq.push(['record', 'Post', {'Schema': post.get("schema"), 'ID': post.id}]) if _kmq?
        CommonPlace.community.transactions.trigger "sync"
        @showShareModal(post, "Thanks for posting!", "Share your post with your friends!")
        if self.hasImageFile
          self.imageUploader.submit()

        $.ajax(
          type: "POST"
          url: "/api" + post.get("links").self + "/add_image"
          data:
            "image_id" : post.get("image_id")
          success: (response) ->
          dataType: "JSON"
        )
        self.render()
      , this)

      error: (attribs, response) ->
        _kmq.push(['record', 'Post Error', {'Attributes': attribs}]) if _kmq?
        self.$("button").show()
        self.$(".spinner").hide()
        self.showError response
)
