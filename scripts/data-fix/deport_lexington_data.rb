class ImportLexingtonData < ActiveRecord::Base

  community = Community.find_by_slug("lexington")
  s = Rails.root.join("scripts", "data-fix", "LexMelissadata.csv")
  CSV.foreach(s, :headers => true) do |row|
    h = row.to_hash

    street = h["ADDRESS"].squeeze(" ").strip

    r = Resident.find_by_address(street)
    r.destroy if !r.nil?

    s = StreetAddress.find_by_address(street)
    s.destroy

  end
end
