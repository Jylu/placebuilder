require 'smtp_api_header.rb'

class NotificationsMailer < ActionMailer::Base
  helper :text
  helper_method :url
  include TextHelper
  @queue = :notifications_mailer

  def url(path = "")
    "http://" + @community.slug + ".ourcommonplace.com" + path
  end

  RECIPIENT = "sengrid@example.com"
  def self.perform(notified_type, notifiable_type, 
                   notified_id, notifiable_id)
    
    notified = notified_type.constantize.find(notified_id.to_i)
    notifiable = notifiable_type.constantize.find(notifiable_id.to_i)
    method = [notified_type, notifiable_type].join("_").downcase
    self.send("deliver_#{method}", notified, notifiable)
  end

  
  def neighborhood_post(neighborhood, post)
    recipients RECIPIENT
    @community = neighborhood.community
    users = neighborhood.users.reject{|u| u == post.user}.select(&:receive_posts)
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{post.user.full_name} posted to your neighborhood"
    from "CommonPlace <#{post.long_id}@replies.commonplaceusa.com>"
    body :post => post
  end
  
  def user_message(user, message)
    @community = user.community
    recipients user.email
    from "CommonPlace <messages@commonplaceusa.com>"
    subject "#{message.user.name} just sent you a message on CommonPlace"
    body :message => message
  end

  def post_reply(post, reply)
    @community = post.user.community
    users = (post.replies.map(&:user) + [post.user]).uniq.reject {|u| u == reply.user}
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    recipients post.user.email
    from "CommonPlace <#{post.long_id}@replies.commonplaceusa.com>"
    subject "#{reply.user.name} just replied to a post on CommonPlace"
    body :reply => reply, :post => post
  end

  def feed_event(feed, event)
    @community = feed.community
    recipients RECIPIENT
    users = feed.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    users feed.subscribers.map(&:email)
    subject "#{feed.name} posted a new event"
    from "events@commonplaceusa.com"
    body :feed => feed, :event => event
  end

  def feed_announcement(feed, announcement)
    @community = feed.community
    recipients RECIPIENT
    users = feed.subscribers
    header = SmtpApiHeader.new
    header.addTo(users.map(&:email))
    header.addSubVal('<name>', users.map(&:name))
    @headers['X-SMTPAPI'] = header.asJSON
    subject "#{feed.name} posted a new announcement"
    from "announcements@commonplaceusa.com"
    body :feed => feed, :announcement => announcement
  end
end
