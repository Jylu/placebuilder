Home.model.Page = Backbone.Model.extend(
  initialize: ->
    this.messages = new Home.model.Messages([], {uri: this.get("links").messages})
    this.announcements = new Home.model.Announcements([], {uri: this.get("links").announcements})

  validate: (attribs) ->
    missing = []
    missing.push "feed name"  unless attribs.name
    missing.push "nickname"  unless attribs.slug
    if missing.length > 0
      responseText = "Please fill in the " + missing.shift()
      _.each missing, (field) ->
        responseText = responseText + " and " + field

      response =
        status: 400
        responseText: responseText + "."

      response

  cropAvatar: (coords, callback) ->
    $.ajax
      contentType: "application/json"
      url: "/api" + @get("links").crop
      type: "put"
      dataType: "json"
      data: JSON.stringify(
        crop_x: coords.crop_x
        crop_y: coords.crop_y
        crop_w: coords.crop_w
        crop_h: coords.crop_h
      )
      success: _.bind((feed) ->
        @set feed
        callback()  if callback
      , this)

  deleteAvatar: (callback) ->
    self = this
    $.ajax
      contentType: "application/json"
      url: "/api" + @get("links").avatar_edit
      type: "delete"
      dataType: "json"
      success: (account) ->
        self.set account
        callback and callback()
)

Home.model.Pages = Backbone.Collection.extend(model: Home.model.Page)
