class Home.presenter.Post

  constructor: (@post) ->


  toJSON: ->
    _.extend(@post.toJSON(),
      wireCategoryClass: "sports"
      wireCategoryName: (this.post.attributes.category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
      timeAgo: timeAgoInWords(@post.get("published_at")))



