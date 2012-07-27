class AddInviteCountToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :invite_count, :integer, null:false, :default => 0
    User.find_each do |user|
      @invite=Invite.where(:inviter_id=>user.id).count
      user.update_attribute(:feeds_count, @invite)
      user.save
    end
    
  end
  def self.down
    remove_column :users, :invite_count
  end
end
