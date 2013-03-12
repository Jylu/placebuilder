CommonPlace.main.WelcomeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.welcome"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @fadeIn @el

  user_name: ->
    full_name = CommonPlace.account.get("name")
    (if (full_name) then full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @finish()

  finish: ->
    @nextPage "profile", @data
)
