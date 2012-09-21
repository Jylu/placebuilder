class SinglePostEmail < MailBase

  def initialize(user_email, user_first_name, user_community_name, community_locale, community_slug, date, post)
    @user_email = user_email
    @user_first_name = user_first_name
    @user_community_name = user_community_name
    @community_locale = community_locale
    @community_slug = community_slug
    @date = DateTime.parse(date)
    @posts = post
  end

  def logo_url
    asset_url("logo2.png")
  end

  def reply_button_url
    asset_url("reply-button.png")
  end

  def invite_them_now_button_url
    asset_url("invite-them-now-button.png")
  end
  
  # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
  def short_user_name
    @user_first_name
  end

  def text
    # TODO: Do this more elegantly. To make daily digests idempotent, this had to be hacked together.
    @text ||= YAML.load_file(File.join(File.dirname(__FILE__), "text", "#{@community_locale}.yml"))[self.underscored_name]
  end

  def from
    "#{community_name} CommonPlace <notifications@#{@community_slug}.ourcommonplace.com>"
  end

  def subject
    "New post in the #{community_name} CommonPlace"
  end

  def to
    @user_email
  end

  def header_text
    @date.strftime("%A, %B %d, %Y")
  end

  def community_name
    @user_community_name
  end

  def deliver?
    posts_present || announcements_present || events_present
  end

  def deliver
    if deliver?
      mail = Mail.deliver(:to => self.to,
                          :from => self.from,
                          :reply_to => self.reply_to,
                          :subject => self.subject,
                          :content_type => "text/html",
                          :body => self.render_html,
                          :charset => 'UTF-8',
                          :headers => {
                            "Precedence" => "list",
                            "Auto-Submitted" => "auto-generated",
                            "X-Campaign-Id" => @community_slug,
                            "X-Mailgun-Tag" => self.tag
                          })
    end
  end

  def posts_present
    @posts.present?
  end

  def posts
    @posts
  end

  def announcements_present
    @announcements.present?
  end

  def announcements
    @announcements
  end

  def events_present
    @events.present?
  end

  def events
    @events
  end

  def tag
    'single_post_email'
  end

end
