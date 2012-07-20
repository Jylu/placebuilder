class AddLastStoryTimeToResident < ActiveRecord::Migration
  def up
    add_column :residents, :last_story_time, :datetime
    Resident.find_each do |resident|
    @data=resident.find_story
      if @data.count>0
        resident.update_attribute(:last_story_time, @data[0]['published_at'])
        resident.save
      end
    end
  end

  def down
    remove_column :residents, :last_story_time
  end
end
