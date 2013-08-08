CommonPlace.shared.PlaceList = CommonPlace.View.extend(
  template: "shared.place-list"

  events:
    "click .network": "changeList"
    "click .red-button": "goToList"

  initialize: ->
    @current = null
    $.getJSON("/api/communities/0/network_list", _.bind((response) ->
      $lists = @$(".lists")

      response.map((comm) ->
        if comm.network_type is "town"
          html = '<li class="network" id="' + comm.slug + '">' + comm.name + ', ' + comm.state + '</li>'
        else
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
