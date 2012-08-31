class DeportLexingtonData < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
  s = Rails.root.join("script", "data-fix", "LexMelissadata.csv")
  CSV.foreach(s, :headers => true) do |row|
    h = row.to_hash

    street = h["ADDRESS"].squeeze(" ").strip

    r = Resident.find_by_address(street)
    r.destroy if !r.nil?

    s = StreetAddress.find_by_address(street)
    s.destroy if !s.nil?

  end
end
