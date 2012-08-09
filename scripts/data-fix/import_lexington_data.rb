class ImportLexingtonData < ActiveRecord::Base

  community = Community.find_by_slug("test")
    s = Rails.root.join("scripts", "data-fix", "LexMelissadata.csv")
    CSV.foreach(s, :headers => true) do |row|
      h = row.to_hash

      first = h["FirstName"].nil? ? nil : h["FirstName"].capitalize
      last = h["LastName"].nil? ? nil : h["LastName"].capitalize
      name = "#{first} #{last}" if !first.nil? && !last.nil?
      street = h["ADDRESS"].squeeze(" ")
      zip = h["Zip"].to_i

      StreetAddress.create(address: street,
                           carrier_route: h["Crrt"],
                           zip_code: zip,
                           unreliable_name: name,
                           community: community)
    end
end
