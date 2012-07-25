class AddNewTagsAndNotesToResident < ActiveRecord::Migration
  def up
    add_column :residents, :sector_tags, :text
    add_column :residents, :type_tags, :text
    add_column :residents, :notes, :string
  end
  def down
    remove_column :residents, :sector_tags, :text
    remove_column :residents, :type_tags, :text
    remove_column :residents, :notes, :string
  end
end
