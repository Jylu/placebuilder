CommonPlace.main.RulesView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.rules"
  events:
    "click .next-button": "submit"

  afterRender: ->
    unless @current
      @slideIn @el
      @current = true
    $("#directory_content").css
      zIndex: "990"
    $(".red-button").css
      zIndex: "1002"
      position: "relative"

  community_name: ->
    @community.get("name")

  submit: (e) ->
    e.preventDefault()  if e
    @complete()
)
