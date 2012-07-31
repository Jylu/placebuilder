class AddActionTagsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :action_tags, :text
    grouped_sql = "SELECT users.id,users.posts_count,users.replies_count,users.replied_count,users.invites_count,users.announcements_count,users.events_count,users.sign_in_count,users.emails_sent FROM users"
    result = execute(grouped_sql).values[0]
    result.each do |pair|
      next unless pair[0].present? and pair[1].present? and pair[2].present? and pair[3].present? and pair[4].present? and pair[5].present? and pair[6].present? and pair[7].present? and pair[8].present?
      tags=[]
      tags.push("post") if pair[1].present? and pair[1]>0
      tags.push("reply") if pair[2].present? and pair[2]>0
      tags.push("replied") if pair[3].present? and pair[3]>0
      tags.push("invite") if pair[4].present? and pair[4]>0
      tags.push("announcement") if pair[5].present? and pair[5]>0
      tags.push("event") if pair[6].present? and pair[6]>0
      tags.push("sitevisit") if pair[7].present? and pair[7]>0
      tags.push("email") if pair[8].present? and pair[8]>0
      execute("UPDATE users SET action_tags = #{tag} WHERE id = #{pair[0]}")
    end if result.present?
  end

  def self.down
    remove_column :users, :action_tags
  end
end
