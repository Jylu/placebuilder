CommonPlace.shared.AdItem = CommonPlace.View.extend(
  template: "admin.ad-item"
  tagName: "li"

  events: "click .delete": "deleteAd"

  body: ->
    @model.get "body"

  start_date: ->
    @model.get "start_date"

  end_date: ->
    @model.get "end_date"

  deleteAd: (e) ->
    @model.destroy()
)
