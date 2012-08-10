class ImportLexingtonData < ActiveRecord::Base

  community = Community.find_by_name("Lexington")
    s = Rails.root.join("scripts", "data-fix", "LexMelissadata.csv")
    CSV.foreach(s, :headers => true) do |row|
      h = row.to_hash

      first = h["FirstName"].nil? ? nil : h["FirstName"].capitalize.strip
      last = h["LastName"].nil? ? nil : h["LastName"].capitalize.strip
      if !first.nil? && !first.empty? && !last.nil? && !last.empty?
        name = "#{first} #{last}"
      end
      street = h["ADDRESS"].squeeze(" ").strip
      zip = h["Zip"].to_i

      StreetAddress.create(address: street,
                           carrier_route: h["Crrt"],
                           zip_code: zip,
                           unreliable_name: name,
                           community: community)
    end
end
