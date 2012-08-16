#= require_tree ./main_page
CommonPlace.CommunityPage = CommonPlace.View.extend(
  template: "main_page.main-page"
  id: "main"
  track: true
  page_name: "community"
  initialize: (options) ->
    self = this
    @account = CommonPlace.account
    @community = CommonPlace.community
    profileDisplayer = new ProfileDisplayer({})
    #@postBox = new PostBox(
    #  account: @account
    #  community: @community
    #)
    @lists = new CommonPlace.main.CommunityResources(
      account: @account
      community: @community
      showProfile: (p) ->
        profileDisplayer.show p,
          from_wire: true

    )
    #@profileBox = new ProfileBox(profileDisplayer: profileDisplayer)
    @sidebar = new CommonPlace.shared.Sidebar(
      tabs: [{
        title: "pages"
        text: "Your Pages"
      }, {
        title: "neighbors"
        text: "Your Neighbors"
      }]
      tabviews:
        pages: new CommonPlace.shared.YourPages()
        neighbors: new CommonPlace.shared.Neighbors()
      nav: new CommonPlace.shared.YourTown()
    )
      
    profileDisplayer.highlightSingleUser = (user) ->
      self.lists.highlightSingleUser user

    @views = [@sidebar, @lists]

  afterRender: ->
    self = this
    _(@views).each (view) ->
      view.render()
      self.$("#" + view.id).replaceWith view.el

    CommonPlace.layout.reset()

  bind: ->
    $("body").addClass "community"
    CommonPlace.layout.bind()

  unbind: ->
    $("body").removeClass "community"
    CommonPlace.layout.unbind()
)
$ ->
  if Features.isActive("2012Release")
    $("body").addClass "fixedLayout"
    CommonPlace.layout = new FixedLayout()
  else
    CommonPlace.layout = new StaticLayout()

