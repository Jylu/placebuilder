CommonPlace.main.WelcomeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.welcome"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @fadeIn @el

  submit: (e) ->
    e.preventDefault()  if e
    @finish()

  finish: ->
    @nextPage "profile", @data
)
