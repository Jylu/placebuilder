CommonPlace.main.CropView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.crop"
  events:
    "click input.continue": "submit"
    "submit form": "submit"

  afterRender: ->
    @slideIn @el
    $img = @$("img#cropbox")
    self = this
    @coords = {}
    $img.load _.bind(->
      scale = Math.max(380.0 / $img.width(), 300.0 / $img.height())
      @$("form").css
        width: Math.floor($img.width() * scale)
        height: Math.floor(($img.height() * scale) + 50)

      $img.css
        width: Math.floor($img.width() * scale)
        height: Math.floor($img.height() * scale)

      $img.Jcrop
        onChange: (coords) ->
          self.updateCrop coords

        onSelect: (coords) ->
          self.updateCrop coords

        aspectRatio: 1.0
    , this)

  avatar_url: ->
    CommonPlace.account.get "avatar_original"

  updateCrop: (coords) ->
    $img = @$("img#cropbox")
    scale = $img[0].width / $img.width()
    if scale
      @coords =
        crop_x: coords.x * scale
        crop_y: coords.y * scale
        crop_w: coords.w * scale
        crop_h: coords.h * scale

  submit: (e) ->
    e.preventDefault()  if e
    CommonPlace.account.cropAvatar @coords, _.bind(->
      @nextPage "feed", @data
    , this)
)
