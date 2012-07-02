class AddAnnouncementCountToFeed < ActiveRecord::Migration
  def self.up
    add_column :feeds, :announcements_count, :integer, null:false, :default => 0
    Feed.find_each do |feed|
      feed.update_attribute(:announcements_count, feed.announcements.length)
      feed.save
    end
  end
  def self.down
    remove_column :feeds, :announcements_count
  end
end
