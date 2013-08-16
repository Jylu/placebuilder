class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.text :body
      t.string :link
      t.integer :community_id

      t.timestamps
    end
  end
end
