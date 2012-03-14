class Invitation < MailBase

  def initialize(email, inviter_id, name = "Neighbor")
    @to = email
    @inviter = User.find(inviter_id)
    @name = name
  end

  def header_image_url
    asset_url("headers/#{community.slug}.png")
  end

  def subject
    "#{inviter_name} invited you to join The #{community_name} CommonPlace"
  end

  def to
    @to
  end

  def inviter
    @inviter
  end

  def community
    inviter.community
  end

  def invitee_name
    @name || "Neighbor"
  end

  def inviter_avatar
    inviter.avatar? && inviter.avatar_url
  end

  def community_register_url
    "http://www.#{community.slug}.OurCommonPlace.com/"
  end

  def community_name
    community.name
  end

  def inviter_name
    inviter.name
  end

  def short_inviter_name
    inviter.first_name
  end

  def organizer_name
    community.organizer_name
  end
  
  def organizer_email
    community.organizer_email
  end

  def tag
    'invitation'
  end

  def deliver?
    true
  end

  def community_slug
    community.slug 
  end

end
