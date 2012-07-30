class AddActionTagsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :action_tags, :text

    # TODO: This should be done in SQL
    # User.find_each do |user|
      # tags=[]
      # tags.push("post") if user.posts_count.present? and user.posts_count>0
      # tags.push("reply") if user.replies_count.present? and user.replies_count>0
      # tags.push("replied") if user.replied_count.present? and user.replied_count>0
      # tags.push("invite") if user.invites_count.present? and user.invites_count>0
      # tags.push("announcement") if user.announcements_count.present? and user.announcements_count>0
      # tags.push("event") if user.events_count.present? and user.events_count>0
      # tags.push("sitevisit") if user.sign_in_count.present? and user.sign_in_count>0
      # tags.push("email") if user.emails_sent.present? and user.emails_sent>0
      # user.update_attribute(:action_tags, @tags)
      # user.save
    # end
  end

  def self.down
    remove_column :users, :action_tags
  end
end
