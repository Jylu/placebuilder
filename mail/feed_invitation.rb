class FeedInvitation < MailBase

  def initialize(email, feed_id, name = "Neighbor")
    @to = email
    @feed = Feed.find(feed_id)
    @inviter = @feed.user
    @name = name
  end

  def feed
    @feed
  end

  def feed_name
    @feed.name
  end

  def community 
    @feed.community
  end

  def community_name
    community.name
  end

  def subject
    "#{inviter_name} invited you to subscribe to the #{feed_name} community page on CommonPlace"
  end

  def to
    @to
  end

  def invitee_name
    @name
  end

  def inviter_name
    @feed.user.name
  end

  def tag
    'feed_invitation'
  end

  def deliver?
    true
  end

end
