class AddLastStoryTimeToResident < ActiveRecord::Migration
  def up
    add_column :residents, :last_story_time, :datetime
  end

  def down
    remove_column :residents, :last_story_time
  end
end
