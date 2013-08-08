class AddNetworkTypeToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :network_type, :string
  end
end
