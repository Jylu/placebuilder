CommonPlace.shared.AdZone = CommonPlace.View.extend(
  template: "admin.ad-zone"

  events:
    "click .submit": "createAd"
    "click .show": "showAds"

  afterRender: ->
    $.getJSON("/api/communities/0/network_list", _.bind((response) ->
      $networks = @$("#networks")
      $c_networks = @$("#c_networks")

      response.map((comm) ->
        html = '<option value="' + comm.id + '">' + comm.name + '</option>'
        $networks.append(html)
        $c_networks.append(html)
      )
    ))

    _render = _.bind(->
      @ads.map((item) ->
      )
    , this)
    @ads = CommonPlace.community.ads
    @ads.fetch success: _render
    @$("input#start").datepicker dateFormat: "yy-mm-dd"
    @$("input#end").datepicker dateFormat: "yy-mm-dd"
    @data = {}
    @data.image_id = []
    @initImageUploader(@$(".one"), 1)

  showAds: (e)->
    e.preventDefault() if e

    c_id = parseInt(@$("#c_networks").val())
    views = @ads.map((item) ->
      if item.get("community_id") is c_id
        new CommonPlace.shared.AdItem(model: item)
    )

    views = views.filter((n) -> return n)

    _.invoke views, "render"
    $results = @$("#ad-viewer")
    $results.empty()
    $results.append _.pluck(views, "el")

  initImageUploader: ($el, num) ->
    self = this
    @imageUploader = new AjaxUpload($el,
      action: "/api/transactions/image"
      name: "image"
      data: @data
      responseType: "text/html"
      autoSubmit: true
      onChange: ->
        self.hasImageFile = true

      onSubmit: _.bind((file, extension) ->
          $upload_pic = $(".item_pic#" + num)
          $upload_pic.attr("src", "/assets/loading.gif")
          $upload_pic.parent().addClass("loading")
        , this)

      onComplete: _.bind((file, response) ->
          response = $.parseJSON(response)
          $upload_pic = $(".item_pic#" + num)
          $upload_pic.attr("src", response.image_normal)
          $upload_pic.parent().removeClass("loading")
          @data.image_id[num-1] = response.id
        , this)
    )

  createAd: (e) ->
    e.preventDefault()
    @data.community = @$("#networks").val()
    @data.body = @$("#body").val()
    @data.start_date= @$("input#start").val()
    @data.end_date = @$("input#end").val()

    adCollection = CommonPlace.community.ads

    self = this
    adCollection.create @data,
      success: _.bind((post) ->
        if self.hasImageFile
          self.addImageToPost(post)
        alert("Ad added")
        self.render()
        CommonPlace.community.ads.trigger "sync"
      , this)

  addImageToPost: (post) ->
    $.ajax(
      type: "POST"
      url: "/api/transactions/" + post.get("id") + "/ad_image"
      data:
        "image_id" : post.get("image_id")
      success: (response) ->
      dataType: "JSON"
    )
)
