class AddAnnouncementsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :announcements_count, :integer, null:false, :default => 0
    @amount=0
    User.find_each do |user|
      user.managable_feeds.each do |feed|
        @amount+=feed.announcements.length
      end
      user.update_attribute(:announcements_count, user.announcements.length+@amount)
      user.save
    end

  end
  def self.down
    remove_column :users, :announcements_count
  end
end
