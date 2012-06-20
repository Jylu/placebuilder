class AddPhoneAndOrganization < ActiveRecord::Migration
  def change
    add_column :residents, :phone, :integer
    add_column :residents, :organization, :string
  end
end
