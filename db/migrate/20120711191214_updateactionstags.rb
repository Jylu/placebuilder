class Updateactionstags < ActiveRecord::Migration
  def up
    User.find_each do |user|
      @tags=[]
      if !user.posts_count.nil? && user.posts_count > 0
        @tags=@tags.push("post")
      end
      if !user.replies_count.nil? && user.replies_count > 0
        @tags=@tags.push("reply")
      end
      if user.replied_count > 0
        @tags=@tags.push("replied")
      end
      if user.invite_count > 0
        @tags=@tags.push("invite")
      end
      if user.announcements_count > 0
        @tags=@tags.push("announcement")
      end
      if user.events_count > 0
        @tags=@tags.push("event")
      end
      if user.sign_in_count > 0
        @tags=@tags.push("sitevisit")
      end
      if user.emails_sent > 0
        @tags=@tags.push("email")
      end
      user.update_attribute(:actions_tags, @tags)
      user.save
    end
  end

  def down
  end
end
