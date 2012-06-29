class AddRepliedCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :replied_count, :integer, null:false, :default => 0
    @amount=0
    User.find_each do |user|
      user.posts.each do |post|
        @amount+=Reply.where(:repliable_id=>post.user_id).count
      end
      user.update_attribute(:replied_count, @amount)
      user.save
    end
    
  end
  def self.down
    remove_column :users, :replied_count
  end
end
