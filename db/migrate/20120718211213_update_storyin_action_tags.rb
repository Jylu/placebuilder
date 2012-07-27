class UpdateStoryinActionTags < ActiveRecord::Migration
  def up
    add_column :residents, :stories_count, :integer, null:false, :default => 0
  end

  def down
    remove_column :residents, :stories_count
  end
end
