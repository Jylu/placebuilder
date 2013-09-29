class AddAdIdToImage < ActiveRecord::Migration
  def change
    add_column :images, :ad_id, :integer
  end
end
