class AddTimeLimitToAd < ActiveRecord::Migration
  def change
    add_column :ads, :start_date, :date
    add_column :ads, :end_date, :date
  end
end
