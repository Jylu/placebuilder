class AddEventsCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :events_count, :integer, null:false, :default => 0
    User.find_each do |user|
      user.update_attribute(:events_count, user.direct_events.length)
      user.save
    end
    
  end
  def self.down
    remove_column :users, :events_count
  end
end
