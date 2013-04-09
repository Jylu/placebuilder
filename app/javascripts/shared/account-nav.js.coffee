CommonPlace.shared.AccountNav = CommonPlace.View.extend(
  template: "shared.account-nav"
  className: "nav"

  events:
    "click .account": "goToAccount"
    "click .profile": "goToProfile"

  goToAccount: (e) ->
    e.preventDefault() if e
    app.account

  goToProfile: (e) ->
    e.preventDefault() if e
    app.profile
)
