class UpdateStoryinActionTags < ActiveRecord::Migration
  def up
    add_column :residents, :stories_count, :integer, null:false, :default => 0
    Resident.find_each do |resident|
      resident.update_attribute(:stories_count, resident.find_story.count)
      resident.save
    end
  end

  def down
    remove_column :users, :stories_count
  end
end
