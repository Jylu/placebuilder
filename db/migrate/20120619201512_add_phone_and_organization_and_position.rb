class AddPhoneAndOrganizationAndSectorTagAndTypeTagToResident < ActiveRecord::Migration
  def change
    add_column :residents, :phone, :integer
    add_column :residents, :organization, :string
    add_column :residents, :position, :string
  end
end
