class CreateBalancedMerchants < ActiveRecord::Migration
  def change
    create_table :balanced_merchants do |t|
      t.references :user, :null => false
      t.string :account, :null => false
      t.datetime :valid_at, :null => false
      t.datetime :invalid_at

      t.timestamps
    end
    add_index :balanced_merchants, :user_id
  end
end
