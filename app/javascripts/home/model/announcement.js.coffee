Home.model.Announcement = Backbone.Model.extend(
  validate: (attributes) ->
    missing = []
    if not attributes.title
      missing.push "title"
    if not attributes.body
      missing.push "body"
    if missing.length > 0
      responseText = "Please fill in the " + missing.shift()
      _.each(missing,
        (field) ->
          responseText = responseText + " and " + field
      )
      response = 
        "status": 400,
        "responseText": responseText + "
        ."
)

Home.model.Announcements = Backbone.Collection.extend(model: Home.model.Announcement)
