class CreateGroupPostsGroupsTable < ActiveRecord::Migration
  def change
    create_table :group_posts_groups do |t|
      t.belongs_to :group
      t.belongs_to :group_post
    end
  end
end
