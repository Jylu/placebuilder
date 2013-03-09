CommonPlace.main.TransactionForm = CommonPlace.main.BaseForm.extend(
  template: "main_page.forms.transaction-form"
  className: "create-transaction transaction"

  afterRender: ->
    @data = {}
    @data.image_id = []
    @$("input[placeholder], textarea[placeholder]").placeholder()
    if @imageUploadSupported() and not @isPostEdit()
      @initImageUploader(@$(".image_file_browser#1"), 1)
      @initImageUploader(@$(".image_file_browser#2"), 2)
      @initImageUploader(@$(".image_file_browser#3"), 3)
    else
      @$(".image_file_browser").hide()
    @hideSpinner()
    self = this
    @populateFormData()

  imageUploadSupported: ->
    return (not @isIE8orBelow())

  initImageUploader: ($el, num) ->
    self = this
    @imageUploader = new AjaxUpload($el,
      action: "/api/transactions/image"
      name: "image"
      data: @data
      responseType: "json"
      autoSubmit: true
      onChange: ->
        @hasImageFile = true

      onSubmit: _.bind((file, extension) ->
          $upload_pic = $(".item_pic#"+num)
          $upload_pic.attr("src", "/assets/loading.gif")
          $upload_pic.parent().addClass("loading")
        , this)

      onComplete: _.bind((file, response) ->
          $upload_pic = $(".item_pic#" + num)
          $upload_pic.attr("src", response.image_normal)
          $upload_pic.parent().removeClass("loading")
          #$(".box").append('<img src="'+response.image_url+'" alt="This is a picture of the item for sale" /><br/>')
          @data.image_id = response.id
        , this)
    )

  createPost: (e) ->
    e.preventDefault()
    @cleanUpPlaceholders()
    @showSpinner()
    @disableSubmitButton()

    number = @$("[name=price]").val()
    if number.length > 0
      price = Number(number.replace(/[^0-9\.]+/g, "") * 100).toFixed(2)
    @data.title = @$("[name=title]").val()
    @data.price = price
    @data.body = @$("[name=body]").val()

    @sendPost CommonPlace.community.transactions, @data

  sendPost: (transactionCollection, data) ->
    self = this
    if @isPostEdit()
      for key, value of data
        @model.set(key, value)
      @model.save()
      @exit()
    else
      transactionCollection.create data,
        success: _.bind((post) ->
          if self.imageUploadSupported()
            if self.imageUploader.hasImageFile
              self.addImageToPost(post)
          self.render()
          CommonPlace.community.transactions.trigger "sync"
          @showShareModal(post, "Thanks for posting!", "You've just shared this post with #{@getUserCount()} neighbors in #{@community_name()}. Share with some more people!")
          _kmq.push(['record', 'Post', {'Schema': post.get("schema"), 'ID': post.id}]) if _kmq?
        , this)

        error: (attribs, response) ->
          _kmq.push(['record', 'Post Error', {'Attributes': attribs}]) if _kmq?
          self.enableSubmitButton()
          self.showError response.responseText

  addImageToPost: (post) ->
    $.ajax(
      type: "POST"
      url: "/api" + post.get("links").self + "/add_image"
      data:
        "image_id" : post.get("image_id")
      success: (response) ->
      dataType: "JSON"
    )
)
