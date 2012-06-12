class Home.presenter.Post

  constructor: (@post) ->


  toJSON: ->
    category = this.post.attributes.category
    if category is null
      category = "discussion"
    else if category is undefined
      category = "discussion"
    _.extend(@post.toJSON(),
      wireCategoryClass: category
      wireCategoryName: (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
      timeAgo: timeAgoInWords(@post.get("published_at")))



