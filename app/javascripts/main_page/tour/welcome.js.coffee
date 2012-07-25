CommonPlace.main.WelcomeView = CommonPlace.main.TourModalPage.extend(
  template: "main_page.tour.home_welcome"
  events:
    "click .next-button": "submit"

  afterRender: ->
    @slideIn @el

  community_name: ->
    @community.get("name")

  user_name: ->
    (if (@data.full_name) then @data.full_name.split(" ")[0] else "")

  submit: (e) ->
    e.preventDefault()  if e
    @finish()

  finish: ->
    @nextPage "profile", @data
)
