class Home.presenter.Post

  constructor: (@post) ->


  processReply: (reply) ->
   reply.time_ago = timeAgoNamedDays(reply.published_at)
   reply.num_thanks = reply.thanks.length
   if reply.num_thanks is 1
      reply.thank_people = "person"
   else
      reply.thank_people = "people"

  toJSON: ->
    category = @post.get("category")
    if category is null
      category = "discussion"
    else if category is undefined
      category = "discussion"
    
    num_thanks = @post.get("thanks").length
    @post.set("num_thanks", num_thanks)
    if num_thanks is 1
      @post.set("thank_people", "person")
    else
      @post.set("thank_people", "people")


    replies = @post.get("replies")
    this.processReply(reply) for reply in replies

    _.extend(@post.toJSON(),
      wireCategory: category
      wireCategoryName: (category.split(' ').map (word) -> word[0].toUpperCase() + word[1..-1].toLowerCase()).join ' '
      publishDate = @post.get("published_at")
      timeAgoISO: publishDate
      timeAgoWords: timeAgoNamedDays(publishDate))



