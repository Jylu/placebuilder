class CreateImages < ActiveRecord::Migration
  def change
    drop_table :images

    create_table :images do |t|
      t.integer :user_id
      t.integer :imageable_id
      t.string :image_file_name
      t.string :image_content_type
      t.string :image_file_size
      t.string :image_updated_at

      t.timestamps
    end
  end
end
