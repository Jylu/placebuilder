class AddFeedsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :feeds_count, :integer, null:false, :default => 0
    User.find_each do |user|
      user.update_attribute(:feeds_count, user.managable_feeds.length)
      user.save
    end
    
  end
  def self.down
    remove_column :users, :feeds_count
  end
end
