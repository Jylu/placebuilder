CommonPlace.shared.PlaceList = CommonPlace.View.extend(
  template: "shared.place-list"

  event:
    "click .townList": "changeList"
    "click .red-button": "goToList"

  initialize: ->
    @current = null
    $.getJSON("/api/communities/Springfield/community_list", _.bind((response) ->
      $lists = @$(".lists")

      response.map((comm) ->
        html = '<li class="townList" id="' + comm.slug + '">' + comm.name + '</li>'
        $lists.append(html)
      )
    ))

  changeList: ->
    return null

  goToList: ->
    unless @current = null
      window.location.pathname = "/"+ @current
)
