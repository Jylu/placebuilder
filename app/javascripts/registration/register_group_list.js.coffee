CommonPlace.registration.GroupListView = CommonPlace.registration.RegistrationModalPage.extend(
  template: "registration.group"
  events:
    "click input.continue": "submit"
    "submit form": "submit"

  afterRender: ->
    groups = @communityExterior.groups
    $ul = @$("ul.groups_container")
    _.each groups, _.bind((group) ->
      itemView = new @GroupItem(model: group)
      itemView.render()
      $ul.append itemView.el
    , this)
    @slideIn @el
    height = 0
    @$(".groups_container li").each (index) ->
      return false  if index is 3
      height = height + $(this).outerHeight(true)

    @$("ul").height height + "px"

  community_name: ->
    @communityExterior.name

  submit: (e) ->
    e.preventDefault()  if e
    groups = _.map(@$("input[name=groups_list]:checked"), (group) ->
      $(group).val()
    )
    if _.isEmpty(groups)
      @finish()
    else
      CommonPlace.account.subscribeToGroup groups, _.bind(->
        @finish()
      , this)

  finish: ->
    if @communityExterior.has_residents_list
      @nextPage "neighbors", @data
    else
      @complete()

  GroupItem: CommonPlace.View.extend(
    template: "registration.group-item"
    tagName: "li"
    events:
      click: "check"

    initialize: (options) ->
      @model = options.model

    avatar_url: ->
      @model.avatar_url

    group_id: ->
      @model.id

    group_name: ->
      @model.name

    about: ->
      @model.about

    check: (e) ->
      e.preventDefault()  if e
      $checkbox = @$("input[type=checkbox]")
      if $checkbox.attr("checked")
        $checkbox.removeAttr "checked"
        @$(".check").removeClass "checked"
      else
        $checkbox.attr "checked", "checked"
        @$(".check").addClass "checked"
  )
)
