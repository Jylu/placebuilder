class CreateBalancedCreditCards < ActiveRecord::Migration
  def change
    create_table :balanced_credit_cards do |t|
      t.reference :user, :null => false
      t.string :account, :null => false
      t.datetime :valid_at, :null => false
      t.datetime :invalid_at

      t.timestamps
    end
  end
end
