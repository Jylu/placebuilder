class CreateOffers < ActiveRecord::Migration
  def change
    create_table :offers do |t|
      t.references :transaction, :null => false
      t.references :message, :null => false
      t.references :reply
      t.integer :price

      t.timestamps
    end
    add_index :offers, :transaction_id
    add_index :offers, :message_id
    add_index :offers, :reply_id
  end
end
