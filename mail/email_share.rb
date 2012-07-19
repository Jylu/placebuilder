class EmailShare < MailBase

  def initialize(recipients, postlike_id, postlike_type, community_id, sharing_user_id)
    @recipients = recipients
    @postlike = postlike_type.constantize.find(postlike_id)
    @postlike_type = postlike_type
    @community = Community.find(community_id)
    @sharing_user = User.find(sharing_user_id)
  end

  def post_type
    @postlike_type
  end

  def postlike
    @postlike
  end

  def poster_avatar_url
    asset_url(poster.try(:avatar_url, :thumb) || "")
  end

  def post_body
    @postlike.body
  end

  def post_url
    show_post_url(postlike.id) if post_type == "Post"
  end

  def short_poster_name
    poster.first_name
  end

  def new_message_url
    if poster.is_a? User
      message_user_url(poster.id)
    elsif poster.is_a? Feed
      message_feed_url(poster.id)
    end
  end

  def post_subject
    @postlike.subject
  end

  def to
    @recipients
  end

  def user
    @postlike.try(:owner)
  end

  def poster
    user
  end

  def sharer_name
    @sharing_user.first_name
  end

  def community
    @community
  end

  def community_name
    community.name
  end

  def short_user_name
    if user.is_a? User
      user.first_name
    elsif user.is_a? Feed
      user.name
    end
  end

  def organizer_email
    community.organizer_email
  end

  def organizer_name
    community.organizer_name
  end

  def subject
    "#{short_user_name}'s #{post_type.titlecase} was just shared with you via the #{community_name} CommonPlace"
  end

  def tag
    "email_postlike_share"
  end

  # def deliver?
    # true
  # end

end
