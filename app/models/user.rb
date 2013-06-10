class NamedPoint
  attr_accessor :lat, :lng, :name, :address
end

class User < ActiveRecord::Base
  require 'amatch'
  include Amatch
  include Geokit::Geocoders
  include Trackable

  before_save :ensure_authentication_token

  serialize :metadata, Hash
  serialize :action_tags, Array
  serialize :private_metadata, Hash

  acts_as_taggable

  acts_as_taggable_on :skills, :interests, :goods

  devise :trackable, :database_authenticatable, :encryptable, :token_authenticatable, :recoverable, :omniauthable, :omniauth_providers => [:facebook]

  geocoded_by :normalized_address

  has_one :resident
  belongs_to :community
  belongs_to :neighborhood
  has_many :thanks, :dependent => :destroy
  has_many :warnings, :dependent => :destroy

  has_many :swipes
  has_many :swiped_feeds, :through => :swipes, :class_name => "Feed", :source => :feed

  has_many :sell_transactions, :class_name => 'Transaction', :as => :owner, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :buy_transactions, :class_name => 'Transaction', :foreign_key => 'buyer_id'

  has_many :attendances, :dependent => :destroy

  has_many :events, :through => :attendances
  has_many :posts, :dependent => :destroy
  has_many :group_posts, :dependent => :destroy
  has_many :announcements, :dependent => :destroy, :as => :owner, :include => :replies
  has_many :images, :as => :imageable, :dependent => :destroy

  has_many :replies, :dependent => :destroy

  has_many :subscriptions, :dependent => :destroy
  accepts_nested_attributes_for :subscriptions
  has_many :feeds, :through => :subscriptions, :uniq => true

  has_many :memberships, :dependent => :destroy
  accepts_nested_attributes_for :memberships
  has_many :groups, :through => :memberships, :uniq => true

  has_many :feed_owners
  has_many :managable_feeds, :through => :feed_owners, :class_name => "Feed", :source => :feed
  has_many :direct_events, :class_name => "Event", :as => :owner, :include => :replies, :dependent => :destroy

  has_many :referrals, :foreign_key => "referee_id"
  has_many :sent_messages, :dependent => :destroy, :class_name => "Message"

  has_many :received_messages, :as => :messagable, :class_name => "Message", :dependent => :destroy

  has_many :messages

  has_many :mets, :foreign_key => "requester_id"

  has_many :people, :through => :mets, :source => "requestee"

  after_create :track_on_creation
  after_destroy :track_on_deletion

  before_validation :geocode, :if => :address_changed?
  before_validation :place_in_neighborhood

  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, allow_blank: true
  validates_presence_of :community

  validates_presence_of :first_name, :unless => :is_transitional_user
  validate :validate_first_and_last_names, :unless => :is_transitional_user
  validates_presence_of :first_name, :last_name

  validates_presence_of :neighborhood, :unless => :is_transitional_user
  validates_uniqueness_of :facebook_uid, :allow_blank => true

  validates_presence_of :encrypted_password, :if => :validate_password?

  validates_presence_of :email
  validates_uniqueness_of :email

  # HACK HACK HACK TODO: This should be in the database schema, or slugs for college towns should ALWAYS be the domain suffix
  validates_format_of :email, :with => /^([^\s]+)umw\.edu/, :if => :college?

  scope :between, lambda { |start_date, end_date|
    { :conditions =>
      ["? <= users.created_at AND users.created_at < ?", start_date.utc, end_date.utc] }
  }

  scope :today, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_day, DateTime.now.utc.end_of_day] }

  scope :this_week, { :conditions => ["created_at between ? and ?", DateTime.now.utc.beginning_of_week, DateTime.now.utc.end_of_day] }

  scope :up_to, lambda { |end_date| { :conditions => ["users.created_at <= ?", end_date.utc] } }

  scope :logged_in_since, lambda { |date| { :conditions => ["last_login_at >= ?", date.utc] } }

  scope :core, {
    :joins => "LEFT OUTER JOIN communities ON (users.community_id = communities.id)",
    :conditions => "communities.core = true",
    :select => "users.*"
  }

  # HACK HACK HACK avatar_url should not be hardcoded like this
  scope :pretty, { :conditions => ["about != '' OR goods != '' OR interests != '' OR avatar_file_name IS NOT NULL"] }

  scope :have_sent_messages, lambda {|user| joins(:received_messages).where(messages: { user_id: user.id }) }

  scope :receives_weekly_bulletin, :conditions => {:receive_weekly_digest => true}

  scope :receives_daily_bulletin, :conditions => {:post_receive_method => ["Live", "Three", "Daily"]}

  scope :receives_posts_live, :conditions => {:post_receive_method => ["Live", "Three"]}

  scope :receives_posts_live_unlimited, :conditions => {:post_receive_method => "Live"}

  scope :receives_posts_live_limited, :conditions => {:post_receive_method => "Three"}

  include CroppableAvatar
  has_attached_file(:avatar,
                    {:styles => {
                        :thumb => {:geometry => "100x100", :processors => [:cropper]},
                        :normal => {:geometry => "120x120", :processors => [:cropper]},
                        :large => {:geometry => "200x200", :processors => [:cropper]},
                        :original => "1000x1000>"
                      },
                      :default_url => "https://s3.amazonaws.com/commonplace-avatars-production/missing.png"
                    }.merge(Rails.env.development? || Rails.env.test? ?
                            { :path => ":rails_root/public/system/users/:id/avatar/:style.:extension",
                              :storage => :filesystem,
                              :url => "/system/users/:id/avatar/:style.:extension"
                            } : {
                              :storage => :s3,
                              :s3_protocol => "https",
                              :bucket => "commonplace-avatars-#{Rails.env}",
                              :path => "/users/:id/avatar/:style.:extension",
                              :s3_credentials => {
                                :access_key_id => ENV['S3_KEY_ID'],
                                :secret_access_key => ENV['S3_KEY_SECRET']
                              }
                            }))

  acts_as_api

  api_accessible :default do |t|
    t.add :id
    t.add lambda {|u| u.id}, :as => :user_id
    t.add lambda {|u| "users"}, :as => :schema
    t.add lambda {|u| u.avatar_url(:normal)}, :as => :avatar_url
    t.add lambda {|u| "/users/#{u.id}"}, :as => :url
    t.add :name
    t.add :first_name
    t.add :last_name
    t.add :about
    t.add :organizations
    t.add :interest_list, :as => :interests
    t.add :good_list, :as => :goods
    t.add :skill_list, :as => :skills
    t.add :links
    t.add lambda {|u| u.posts.count}, :as => :post_count
    t.add lambda {|u| u.replies.count}, :as => :reply_count
    t.add lambda {|u| u.sell_transactions.count}, :as => :sell_count
    t.add lambda {|u| u.thanks_received.count}, :as => :thank_count
    t.add lambda {|u| u.people.count}, :as => :met_count
    t.add lambda {|u| u.pages}, :as => :pages
    t.add lambda {|u| "true" }, :as => :success
    t.add :unread
    t.add lambda {|u| "User"}, :as => :classtype
    t.add lambda {|u| u.action_tags}, :as => :actionstags
  end

  def self.find_for_facebook_oauth(access_token)
    User.find_by_facebook_uid(access_token["uid"])
  end

  def self.new_from_facebook(params, facebook_data)
    u = User.find_by_email(facebook_data["info"]["email"])
    if !u.nil?
      u.facebook_uid = facebook_data["uid"]
    else
      u = User.new(params).tap do |user|
        user.email = facebook_data["info"]["email"]
        user.full_name = facebook_data["info"]["name"]
        user.facebook_uid = facebook_data["uid"]
        user.neighborhood_id = Neighborhood.where(community_id: params[:community_id]).first.id
      end
    end

    return u
  end

  def self.post_receive_options
    ["Live", "Three", "Daily", "Never"]
  end

  def organizer_data_points
    OrganizerDataPoint.find_all_by_organizer_id(self.id)
  end

  def facebook_user?
    self.facebook_uid? || self.private_metadata.has_key?("fb_access_token")
  end

  def validate_password?
    if facebook_user?
      return false
    end
    return true
  end

  def college?
    self.community and self.community.is_college
  end

  def self.find_by_email(email)
    where("LOWER(users.email) = ?", email.try(:downcase)).first
  end

  def self.find_by_full_name(full_name)
    name = full_name.split(" ")
    u = where("LOWER(users.last_name) ILIKE ? AND LOWER(users.first_name) ILIKE ?", name.last, name.first)

    return u if !u.empty?

    nil
  end

  def reset_password(new_password = "cp123")
    self.password = new_password
    self.password_confirmation = new_password
    self.save
  end

  def pages
    self.managable_feeds.map do |feed|
      {"name" => feed.name,
        "id" => feed.id,
        "slug" => feed.slug.blank? ? feed.id : feed.slug
      }
    end
  end

  def links
    {
      "author" => "/users/#{id}",
      "messages" => "/users/#{id}/messages",
      "self" => "/users/#{id}",
      "postlikes" => "/users/#{id}/postlikes",
      "history" => "/users/#{id}/history"
    }
  end

  def avatar_geometry(style = :original)
    @geometry ||= {}
    path = (avatar.options[:storage]==:s3) ? avatar.url(style) : avatar.path(style)
    @geometry[style] ||= Paperclip::Geometry.from_file(path)
  end

  def messages
    self.sent_messages.select {|m| m.replies.count > 0 }
  end

  def validate_first_and_last_names
    errors.add(:full_name, "CommonPlace requires people to register with their first \& last names.") if first_name.blank? || last_name.blank?
  end

  def daily_subscribed_announcements
    self.subscriptions.all(:conditions => "receive_method = 'Daily'").
      map(&:feed).map(&:announcements).flatten
  end

  def suggested_events
    []
  end

  def total_posts
    self.posts.count + self.events.count + self.announcements.count
  end

  def full_name
    [first_name,middle_name,last_name].select(&:present?).join(" ")
  end

  def full_name=(string)
    split_name = string.to_s.split(" ")
    self.first_name = split_name.shift.to_s.capitalize
    self.last_name = split_name.pop.to_s.capitalize
    self.middle_name = split_name.map(&:capitalize).join(" ")
    self.full_name
  end

  def name
    full_name
  end

  def wire
    if new_record?
      community.announcements + community.events
    else
      subscribed_announcements + community.events + neighborhood.posts
    end.sort_by do |item|
      ((item.is_a?(Event) ? item.start_datetime : item.created_at) - Time.now).abs
    end
  end

  def role_symbols
    if new_record?
      [:guest]
    else
      [:user]
    end
  end

  def feed_list
    feeds.map(&:name).join(", ")
  end

  def group_list
    groups.map(&:name).join(", ")
  end

  def feed_messages
    Message.where("messagable_type = 'Feed' AND messagable_id IN (?)", self.managable_feed_ids)
  end

  def place_in_neighborhood
    self.neighborhood = self.community.neighborhoods.first
  end

  def is_facebook_user
    facebook_uid.present?
  end

  def facebook_avatar_url
    "https://graph.facebook.com/" + self.facebook_uid.to_s + "/picture/?type=large"
  end

  def avatar_url(style_name = nil)
    if is_facebook_user && !self.avatar.file?
      facebook_avatar_url
    else
      self.avatar.url(style_name || self.avatar.default_style)
    end
  end

  def value_adding?
    self.posts.count > 0 or self.announcements.count > 0 or self.direct_events.count > 0 or self.group_posts.count > 0
  end

  def normalized_address
    if address.match(/#{self.community.name}/i)
      address
    else
      address + ", #{self.community.name}"
    end
  end

  def generate_point
    if self.attempted_geolocating or (self.generated_lat.present? and self.generated_lng.present?)
      if self.attempted_geolocating and not self.generated_lat.present?
        return
      end
    else
      self.attempted_geolocating = true
      loc = MultiGeocoder.geocode("#{self.address}, #{self.community.zip_code}")
      self.generated_lat = loc.lat
      self.generated_lng = loc.lng
      self.save
    end
    point = NamedPoint.new
    point.lat = self.generated_lat
    point.lng = self.generated_lng
    point.name = self.full_name
    point.address = self.address
    point
  end

  def self.received_reply_to_object_in_last(repliable_type, days_ago)
    # We expect repliable_type to be Post
    if repliable_type == 'Post'
      item = Post
    elsif repliable_type == 'Event'
      item = Event
    elsif repliable_type == 'Announcement'
      item = Announcement
    end
    user_ids = []
    Reply.between(days_ago.days.ago, Time.now).select {|r| r.repliable_type == repliable_type}.map(&:repliable_id).uniq.each do |i| user_ids << item.find(i).owner end
    user_ids
  end

  def emails_are_limited?
    self.post_receive_method == "Three"
  end

  def meets_limitation_requirement?
    self.emails_sent <= 3
  end

  def inbox
    Message.where(<<WHERE, self.id, self.id)
    ("messages"."user_id" = ? AND "messages"."replies_count" > 0) OR
    ("messages"."messagable_type" = 'User' AND
    "messages"."messagable_id" = ?)
WHERE
  end

  searchable do
    text :user_name do
      full_name
    end
    text :about
    text :skills
    text :goods
    text :interests
    integer :community_id
    integer :total_posts
    time :created_at
  end

  def send_reset_password_instructions
    generate_reset_password_token! if should_generate_reset_token?
    kickoff.deliver_password_reset(self)
  end

  def kickoff=(kickoff)
    @kickoff = kickoff
  end

  def kickoff
    @kickoff ||= KickOff.new
  end

  def last_checked_inbox
    read_attribute(:last_checked_inbox) || Time.at(0).to_datetime
  end

  def unread
    (self.inbox + self.feed_messages).select { |m|
      m.updated_at > self.last_checked_inbox
    }.length
  end

  def checked_inbox!
    self.last_checked_inbox = DateTime.now
    self.save :validate => false
  end

  def invitations_this_week
    Invite.this_week.select { |i| i.inviter_id == self.id }
  end

  def all_invitations
    Invite.find_all_by_inviter_id(self.id)
  end

  def replies_received
    (self.posts.map(&:replies) + self.events.map(&:replies) + self.announcements.map(&:replies) + self.group_posts.map(&:replies)).flatten
  end

  def replies_received_this_week
    (self.posts.this_week.map(&:replies) + self.events.this_week.map(&:replies) + self.announcements.this_week.map(&:replies) + self.group_posts.this_week.map(&:replies)).flatten
  end

  def posted_content
    self.posts + self.events + self.announcements + self.group_posts
  end

  def thanks_received
    self.posted_content.map(&:thanks).flatten
  end

  def flags_received
    self.posted_content.map(&:warnings).flatten
  end

  def thanks_received_this_week
    self.posted_content.map{ |content| content.thanks.this_week }.flatten
  end

  def weekly_cpcredits
    self.posts.this_week.count + self.replies.this_week.count + self.replies_received_this_week.count + self.events.this_week.count + self.invitations_this_week.count + self.thanks.this_week.count + self.thanks_received_this_week.count
  end

  def all_cpcredits
    self.posts.count + self.replies.count + self.replies_received.count + self.events.count + self.all_invitations.count + self.thanks.count + self.thanks_received.count
  end

  def profile_history_elements
    self.posts +
      self.direct_events +
      self.announcements +
      self.group_posts +
      self.sell_transactions +
      self.replies.where("repliable_type != 'Message'")
  end

  def profile_history
    self.profile_history_elements
      .sort_by(&:created_at)
      .reverse
      .map {|e| e.as_api_response(:history) }
  end

  def disabled?
    self.disabled
  end

  searchable do
    text :name do
      self.name
    end
  end

  def activity
    Activity.new(self)
  end

  def validation_errors
    UserErrors.new(self)
  end

  def received_spam_report
    index = User.post_receive_options.index self.post_receive_method
    index += 1
    unless index == User.post_receive_options.length
      self.post_receive_method = User.post_receive_options[index]
      self.save
    end
    KickOff.new.send_spam_report_received_notification(self)
  end

  private

  def is_transitional_user
    transitional_user
  end

end
