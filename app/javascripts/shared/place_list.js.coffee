CommonPlace.shared.PlaceList = CommonPlace.View.extend(
  template: "shared.place-list"

  events:
    "click .places": "changeList"
    "click .red-button": "goToList"

  initialize: ->
    @current = null
    $.getJSON("/api/communities/Springfield/community_list", _.bind((response) ->
      $lists = @$(".lists")

      response.map((comm) ->
        html = '<li class="network" id="' + comm.slug + '">' + comm.name + '</li>'
        $lists.append(html)
      )
    ))

  changeList: (e) ->
    @current = e.currentTarget.id
    $(".network").removeClass "current"
    $("#"+@current).addClass "current"

  goToList: ->
    unless @current is null
      window.location.pathname = "/"+ @current
)
